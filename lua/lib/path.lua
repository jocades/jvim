local str = require('utils.str')

local Path = {}

local function _iterdir(path)
  for file in io.popen('ls -a "' .. path .. '"'):lines() do
    if file ~= '.' and file ~= '..' and file ~= '.git' then
      coroutine.yield(file)
    end
  end
end

---@param path string
function Path:new(path)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  if path == nil then
    path = vim.api.nvim_buf_get_name(0)
  end

  o.path = path
  o.name = vim.fn.fnamemodify(path, ':t')
  o.stem = vim.fn.fnamemodify(path, ':t:r')
  o.ext = vim.fn.fnamemodify(path, ':e')

  o.parent = function() return Path:new(vim.fn.fnamemodify(path, ':h')) end

  o.split = function() return str.split(path, '/') end
  o.join = function(...) return Path:new(table.concat({ path, ... }, '/')) end

  o.is_dir = function() return vim.fn.isdirectory(path) == 1 end
  o.is_file = function() return vim.fn.filereadable(path) == 1 end
  o.exists = function() return o.is_dir() or o.is_file() end

  o.iterdir = function()
    if not o.is_dir() then
      error('Cannot iterate a file: ' .. path)
    end

    local files = {}
    for file in io.popen('ls -a "' .. path .. '"'):lines() do
      if file ~= '.' and file ~= '..' and file ~= '.git' then
        table.insert(files, file)
      end
    end

    local i = 0
    local n = #files

    return function()
      i = i + 1
      if i <= n then
        return Path:new(path .. '/' .. files[i])
      end
    end
  end

  o.touch = function()
    if o.is_dir() then
      error('Cannot touch a directory: ' .. path)
    end

    if not o.is_file() then
      local file, err = io.open(path, 'w')

      if not file then
        error('Could not open file: ' .. path .. ' - ' .. err)
      end

      file:close()
    end
  end

  o.mkdir = function()
    if o.is_file() then
      error('Cannot mkdir a file: ' .. path)
    end

    if not o.is_dir() then
      local ok, err = os.execute('mkdir -p ' .. path)

      if not ok then
        error('Could not mkdir: ' .. path .. ' - ' .. err)
      end
    end
  end

  ---@param mode? 'r' | 'rb' | 'w' | 'wb' | 'a' | 'ab'
  o.read = function(mode)
    if o.is_dir() then
      error('Cannot read a directory: ' .. path)
    end

    local file, err = io.open(path, mode or 'r')

    if not file then
      error('Could not open file: ' .. path .. ' - ' .. err)
    end

    local content, error = file:read('*a')
    file:close()

    if not content then
      error('Could not read file: ' .. path .. ' - ' .. error)
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
      error('Cannot write to a directory: ' .. path)
    end

    local file, err = io.open(path, mode or 'w')

    if not file then
      error('Could not open file: ' .. path .. ' - ' .. err)
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

function Path:__tostring() return self.path end

---@param other string | Path
function Path:__div(other)
  if type(other) == 'string' then
    return Path:new(self.path .. '/' .. other)
  end

  return Path:new(self.path .. '/' .. other.path)
end

-- TEST
local p = Path:new('/Users/j0rdi/.config/nvim')

local x = p / 'lua' / 'path.lua'
P(x.path)

local y = p / 'lua'
local z = p / y / 'path.lua'
P(z.path)

for f in (p / 'lua').iterdir() do
  print(f.path)
end

return Path
