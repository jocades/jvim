local str = require('utils.str')

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

local Path = {}

---@param path? string
function Path:new(path)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  if path == nil then
    path = vim.api.nvim_buf_get_name(0)
  end

  o.path = (function()
    if is_uri(path) then
      return path
    end

    if is_absolute(path) then
      return clean(path)
    end

    return clean(vim.fn.fnameescape(vim.fn.fnamemodify(path, ':p')))
  end)()

  o.name = vim.fn.fnamemodify(o.path, ':t')
  o.stem = vim.fn.fnamemodify(o.path, ':t:r')
  o.ext = vim.fn.fnamemodify(o.path, ':e')
  o.parent = function() return Path:new(vim.fn.fnamemodify(o.path, ':h')) end

  o.split = function() return str.split(o.path, SEP) end
  o.join = function(...) return Path:new(table.concat({ o.path, ... }, SEP)) end

  o.is_dir = function() return vim.fn.isdirectory(o.path) == 1 end
  o.is_file = function() return vim.fn.filereadable(o.path) == 1 end
  o.exists = function() return o.is_dir() or o.is_file() end

  o.iterdir = function()
    if not o.is_dir() then
      error('Cannot iterate a file: ' .. o.path)
    end

    local files = {}
    for file in io.popen('ls -a "' .. o.path .. '"'):lines() do
      if file ~= '.' and file ~= '..' and file ~= '.git' then
        table.insert(files, file)
      end
    end

    local i = 0
    local n = #files
    return function()
      i = i + 1
      if i <= n then
        return Path:new(o.path .. SEP .. files[i])
      end
    end
  end

  o.touch = function()
    if o.is_dir() then
      error('Cannot touch a directory: ' .. o.path)
    end

    if not o.is_file() then
      local file, err = io.open(o.path, 'w')

      if not file then
        error('Could not open file: ' .. o.path .. ' - ' .. err)
      end

      file:close()
    end
  end

  o.mkdir = function()
    if o.is_file() then
      error('Cannot mkdir a file: ' .. o.path)
    end

    if not o.is_dir() then
      local ok, err = os.execute('mkdir -p ' .. o.path)

      if not ok then
        error('Could not mkdir: ' .. o.path .. ' - ' .. err)
      end
    end
  end

  ---@param mode? 'r' | 'rb' | 'w' | 'wb' | 'a' | 'ab'
  o.read = function(mode)
    if o.is_dir() then
      error('Cannot read a directory: ' .. o.path)
    end

    local file, err = io.open(o.path, mode or 'r')

    if not file then
      error('Could not open file: ' .. o.path .. ' - ' .. err)
    end

    local content, error = file:read('*a')
    file:close()

    if not content then
      error('Could not read file: ' .. o.path .. ' - ' .. error)
    end

    return str.split(content, '\n')
  end

  o.readlines = function()
    local lines = o.read()
    return function()
      local line = table.remove(lines, 1)
      if line ~= nil then
        return line
      end
    end
  end

  ---@param data string | string[]
  ---@param mode? 'w' | 'a' | 'wb' | 'ab
  o.write = function(data, mode)
    if o.is_dir() then
      error('Cannot write to a directory: ' .. o.path)
    end

    local file, err = io.open(o.path, mode or 'w')

    if not file then
      error('Could not open file: ' .. o.path .. ' - ' .. err)
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

  return o
end

function Path.is_path(o) return getmetatable(o) == Path end

function Path.__tostring(self) return self.path end

function Path.__div(self, other)
  assert(Path.is_path(self))
  assert(Path.is_path(other) or type(other) == 'string')

  return self.join(other)
end

-- TESTS

local tests = {
  -- absolute paths
  '/Users/j0rdi/.config/nvim',
  -- relative paths
  'lua/config/core.lua',
  '../',
  '.',
}

--[[ local p = Path:new('../')
print(p)
print(p.name)

local x = p / 'lua' ]]

-- local p = Path:new('/Users/j0rdi/.config/nvim')

-- local x = p / 'lua' / '/path.lua'
-- print(x.path)
--
-- for f in (p / 'lua').iterdir() do
--   print(f.path)
-- end

-- P(Path:new('../').absolute())

return Path
