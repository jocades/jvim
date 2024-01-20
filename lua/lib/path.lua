local str = require('utils.str')
local class = require('lib.class')

local SEP = '/'

local function is_root(pathname) return pathname == SEP end

local function is_absolute(pathname) return string.sub(pathname, 1, 1) == SEP end

local is_uri = function(filename) return string.match(filename, '^%a[%w+-.]*://') ~= nil end

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

---@generic T, R
---@param ls T[]
---@param callback fun(i: number): R
---@return fun(): R
local function iterator(ls, callback)
  local i = 0
  local n = #ls
  return function()
    i = i + 1
    if i <= n then
      return callback(i)
    end
  end
end

---@class P
---@overload fun(pathname: string): P
---@field path string
---@field name string
---@field stem string
---@field ext string
---@field parent fun(): P
---@field split fun(): string[]
---@field join fun(...): P
---@field is_dir fun(): boolean
---@field is_file fun(): boolean
---@field exists fun(): boolean
---@field iterdir fun(): fun(): P
---@field touch fun(): nil
---@field unlink fun(): nil
---@field mkdir fun(opts?: { parents?: boolean}): nil
---@field rmdir fun(opts?: { force?: boolean}): nil
---@field read fun(mode?: 'r' | 'rb' | 'w' | 'wb' | 'a' | 'ab'): string[]
---@field readlines fun(): fun(): string
---@field write fun(data: string | string[], mode?: 'w' | 'a' | 'wb' | 'ab'): nil
local Path = class()

function Path:new(pathname)
  self.path = (function()
    if is_uri(pathname) then
      return pathname
    end

    if is_absolute(pathname) then
      return clean(pathname)
    end

    return clean(vim.fn.fnameescape(vim.fn.fnamemodify(pathname, ':p')))
  end)()

  self.name = vim.fn.fnamemodify(self.path, ':t')
  self.stem = vim.fn.fnamemodify(self.path, ':t:r')
  self.ext = vim.fn.fnamemodify(self.path, ':e')
  self.parts = str.split(self.path, SEP)

  self.is_dir = function() return vim.fn.isdirectory(self.path) == 1 end
  self.is_file = function() return vim.fn.filereadable(self.path) == 1 end
  self.exists = function() return self.is_dir() or self.is_file() end

  self.parent = function() return Path(vim.fn.fnamemodify(self.path, ':h')) end

  self.join = function(...)
    assert(Path.is_path(self))

    local args = { ... }
    for i, v in ipairs(args) do
      assert(Path.is_path(v) or type(v) == 'string')
      args[i] = tostring(v)
    end

    return Path(self.path .. '/' .. table.concat(args, '/'))
  end

  self.iterdir = function()
    if not self.is_dir() then
      error('Cannot iterate a file: ' .. self.path)
    end

    local files = {}
    for file in io.popen('ls -a "' .. self.path .. '"'):lines() do
      if file ~= '.' and file ~= '..' and file ~= '.git' then
        table.insert(files, file)
      end
    end

    return iterator(files, function(i) return Path(self.path .. SEP .. files[i]) end)
  end

  self.touch = function()
    if self.is_dir() then
      error('Cannot touch a directory: ' .. self.path)
    end

    if not self.is_file() then
      local file, err = io.open(self.path, 'w')

      if not file then
        error('Could not open file: ' .. self.path .. ' - ' .. err)
      end

      file:close()
    end
  end

  self.unlink = function()
    if self.is_dir() then
      error('Cannot unlink a directory: ' .. self.path)
    end

    if self.is_file() then
      local ok, err = os.remove(self.path)

      if not ok then
        error('Could not unlink file: ' .. self.path .. ' - ' .. err)
      end
    end
  end

  self.mkdir = function(opts)
    if self.is_file() then
      error('Cannot mkdir a file: ' .. self.path)
    end

    local parents = opts and opts.parents
    local cmd = parents and 'mkdir -p ' or 'mkdir '

    if not self.is_dir() then
      local ok, err = os.execute(cmd .. self.path)

      if not ok then
        error('Could not mkdir: ' .. self.path .. ' - ' .. err)
      end
    end
  end

  self.rmdir = function(opts)
    if self.is_file() then
      error('Cannot rmdir a file: ' .. self.path)
    end

    local force = opts and opts.force
    local cmd = force and 'rm -rf ' or 'rmdir '

    if self.is_dir() then
      local ok, err = os.execute(cmd .. self.path)

      if not ok then
        error('Could not rmdir: ' .. self.path .. ' - ' .. err)
      end
    end
  end

  self.read = function(mode)
    if self.is_dir() then
      error('Cannot read a directory: ' .. self.path)
    end

    local file, err = io.open(self.path, mode or 'r')

    if not file then
      error('Could not open file: ' .. self.path .. ' - ' .. err)
    end

    local content, error = file:read('*a')
    file:close()

    if not content then
      error('Could not read file: ' .. self.path .. ' - ' .. error)
    end

    return str.split(content, '\n')
  end

  self.readlines = function()
    local lines = self.read()
    return iterator(lines, function(i) return lines[i] end)
  end

  self.write = function(data, mode)
    if self.is_dir() then
      error('Cannot write to a directory: ' .. self.path)
    end

    local file, err = io.open(self.path, mode or 'w')

    if not file then
      error('Could not open file: ' .. self.path .. ' - ' .. err)
    end

    if type(data) == 'table' then
      for _, line in ipairs(data) do
        file:write(line .. '\n')
      end
    else
      file:write(data)
    end

    file:close()
  end
end

function Path.is_path(o) return getmetatable(o) == Path end

function Path.__tostring(self) return self.path end

function Path.__div(self, other) return self.join(other) end

-- TEST
local p = Path('~/.config/nvim/lua/lib')

-- (p / 'test' / 't1').mkdir({ parents = true })
local t1 = p.join('test', 't1')

t1.mkdir({ parents = true })

t1.join('test.txt').write('hello world')

if t1.join('test.txt').exists() then
  t1.join('test.txt').unlink()
end

print(t1.join('test.txt').exists())

return Path
