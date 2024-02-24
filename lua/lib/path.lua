local str = require('utils.str')
local class = require('lib.class')

local SEP = '/'

local function is_root(pathname) return pathname == SEP end

local function is_absolute(pathname) return string.sub(pathname, 1, 1) == SEP end

local is_uri = function(filename)
  return string.match(filename, '^%a[%w+-.]*://') ~= nil
end

local function clean(pathname)
  if is_uri(pathname) then
    return pathname
  end

  -- remove double SEPs
  pathname = string.gsub(pathname, SEP .. SEP, SEP)

  -- remove trailing SEP if not root
  if not is_root(pathname) and pathname:sub(-1) == SEP then
    pathname = pathname:sub(1, -2)
  end

  return pathname
end

---@generic T
---@param pathname string
---@param callback? fun(node: string): T
---@return T[]
local function list(pathname, callback)
  local nodes = {}
  for node in io.popen('ls -a "' .. pathname .. '"'):lines() do
    if node ~= '.' and node ~= '..' then
      if callback then
        table.insert(nodes, callback(node))
      else
        table.insert(nodes, node)
      end
    end
  end
  return nodes
end

---@generic T, R
---@param ls T[]
---@param callback fun(i: integer): R
---@param opts? { enumerate?: boolean }
---@return (fun(): i: integer, R) | (fun(): R)
local function iterator(ls, callback, opts)
  local i = 0
  local n = #ls
  return function()
    i = i + 1
    if i <= n then
      if opts and opts.enumerate then
        return i, callback(i)
      end
      return callback(i)
    end
  end
end

---@param path string
---@param mode 'r' | 'w' | 'a' | 'rb' | 'wb' | 'ab'
local function open(path, mode)
  local file, err = io.open(path, mode)

  if not file then
    error('Could not open file: ' .. path .. ' - ' .. err)
  end

  return file
end

---@class P
---@overload fun(pathname: string | P): P
---@operator div(string | P): P
---@field private _path string The initial path
---@field abs string The absolute path
---@field name string The name of the file or directory
---@field stem string The stem of the file or directory (without extension)
---@field ext string | nil The extension of the file or nil if it does not have one
local Path = class()

function Path:new(pathname)
  self._path = (function()
    if Path.is_path(pathname) then
      return pathname.abs
    end

    if is_uri(pathname) then
      return pathname
    end

    return clean(pathname)
  end)()

  self.abs = clean(vim.fn.fnamemodify(self._path, ':p'))

  self.parts = str.split(self._path, SEP)
  self.name = vim.fn.fnamemodify(self.abs, ':t')
  self.stem = vim.fn.fnamemodify(self.abs, ':t:r')
  self.ext = (function()
    local ext = vim.fn.fnamemodify(self.abs, ':e')
    if ext == '' then
      return nil
    end
    return ext
  end)()

  ---Check if the path is a directory
  self.is_dir = function() return vim.fn.isdirectory(self.abs) == 1 end

  ---Check if the path is a file
  self.is_file = function() return vim.fn.filereadable(self.abs) == 1 end

  ---Check if the path exists
  self.exists = function() return self.is_dir() or self.is_file() end

  ---Get the parent directory
  self.parent = function() return Path(vim.fn.fnamemodify(self.abs, ':h')) end

  ---Get the size of the file in bytes
  ---@return integer
  self.size = (function()
    if self.is_file() then
      return vim.fn.getfsize(self.abs)
    end
    return 0
  end)()

  ---Join the path with other paths
  ---@vararg string | P
  self.join = function(...)
    assert(Path.is_path(self))

    local args = { ... }

    for i, v in ipairs(args) do
      assert(Path.is_path(v) or type(v) == 'string')

      if Path.is_path(v) then
        args[i] = v._path
      end
    end

    return Path(self._path .. SEP .. table.concat(args, SEP))
  end

  ---Iterate over the directory
  self.iterdir = function()
    if not self.is_dir() then
      error('Cannot iterate a file: ' .. self.abs)
    end

    local nodes = list(self.abs)

    return iterator(
      nodes,
      function(i) return Path(self.abs .. SEP .. nodes[i]) end
    )
  end

  ---Get the children of the directory
  self.children = function()
    if not self.is_dir() then
      error('Cannot get children of a file: ' .. self.abs)
    end

    return list(
      self.abs,
      function(node) return Path(self.abs .. SEP .. node) end
    )
  end

  ---Create the file if it does not exist
  self.touch = function()
    if self.is_dir() then
      error('Cannot touch a directory: ' .. self.abs)
    end

    if not self.is_file() then
      open(self.abs, 'w'):close()
    end
  end

  ---Delete the file if it exists
  self.unlink = function()
    if self.is_dir() then
      error('Cannot unlink a directory: ' .. self.abs)
    end

    if self.is_file() then
      local ok, err = os.remove(self.abs)

      if not ok then
        error('Could not unlink file: ' .. self.abs .. ' - ' .. err)
      end
    end
  end

  ---Create the directory if it does not exist
  ---@param opts? { parents?: boolean }
  self.mkdir = function(opts)
    if self.is_file() then
      error('Cannot mkdir a file: ' .. self.abs)
    end

    opts = opts or {}
    local cmd = opts.parents and 'mkdir -p ' or 'mkdir '

    if not self.is_dir() then
      local ok, err = os.execute(cmd .. self.abs)
      if not ok then
        error('Could not mkdir: ' .. self.abs .. ' - ' .. err)
      end
    end
  end

  ---Delete the directory if it exists
  ---@param opts? { force?: boolean }
  self.rmdir = function(opts)
    if self.is_file() then
      error('Cannot rmdir a file: ' .. self.abs)
    end

    opts = opts or {}
    local cmd = opts.force and 'rm -rf ' or 'rmdir '

    if self.is_dir() then
      local ok, err = os.execute(cmd .. self.abs)

      if not ok then
        error('Could not rmdir: ' .. self.abs .. ' - ' .. err)
      end
    end
  end

  ---Read the file
  ---@return string
  self.read = function()
    if self.is_dir() then
      error('Cannot read a directory: ' .. self.abs)
    end

    local file = open(self.abs, 'r')
    local content, err = file:read('*a')
    file:close()

    if not content then
      error('Could not read file: ' .. self.abs .. ' - ' .. err)
    end

    return content
  end

  ---Read the file as lines
  ---@return string[]
  self.readlines = function()
    local content = self.read()
    return str.split(content, '\n')
  end

  ---Iterate over the lines of the file
  ---@param opts? { enumerate?: boolean }
  self.lines = function(opts)
    local lines = self.readlines()
    return iterator(lines, function(i) return lines[i] end, opts)
  end

  ---Read the file as bytes
  ---@return string
  self.readbytes = function()
    if self.is_dir() then
      error('Cannot read a directory: ' .. self.abs)
    end

    local file = open(self.abs, 'rb')
    local content, err = file:read('*a')
    file:close()

    if not content then
      error('Could not read file: ' .. self.abs .. ' - ' .. err)
    end

    return content
  end

  ---Write to the file
  ---@param data string | string[]
  ---@param mode? 'w' | 'a' | 'wb' | 'ab'
  self.write = function(data, mode)
    if self.is_dir() then
      error('Cannot write to a directory: ' .. self.abs)
    end

    local file = open(self.abs, mode or 'w')

    if type(data) == 'table' then
      for _, line in ipairs(data) do
        file:write(line .. '\n')
      end
    else
      file:write(data)
    end

    file:close()
  end

  ---Write to the file as bytes
  ---@param data string | string[]
  self.writebytes = function(data) self.write(data, 'wb') end

  ---Append to the file
  ---@param data string | string[]
  self.append = function(data) self.write(data, 'a') end

  ---Append to the file as bytes
  ---@param data string | string[]
  self.appendbytes = function(data) self.write(data, 'ab') end

  ---Execute the file and capture the output
  ---@param command string | string[]
  ---@param opts? { split?: boolean }
  ---@return string | string[]
  self.exec = function(command, opts)
    opts = opts or {}

    if type(command) == 'table' then
      command = table.concat(command, ' ')
    end

    local output = vim.fn.systemlist(command .. ' ' .. self.abs)

    if opts.split then
      return output
    end

    return table.concat(output, '\n')
  end
end

--
-- Metamethods
--
function Path:__tostring() return self.abs end

function Path:__div(other) return self.join(other) end

function Path:__eq(other) return self.abs == other.abs end

-- can't use __len in lua version < 5.3, nvim uses 5.1 :(
function Path:__len() return #self.parts end

--
-- Class methods
--
function Path.is_root(pathname) return is_root(pathname) end

function Path.is_absolute(pathname) return is_absolute(pathname) end

function Path.is_path(o) return getmetatable(o) == Path end

function Path.cwd() return Path(vim.fn.getcwd()) end

function Path.home() return Path(vim.fn.expand('~')) end

return Path
