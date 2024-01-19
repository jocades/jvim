local str = require('utils.str')

local Path = {}

local function iterdir(path)
  for file in io.popen('ls -a "' .. path .. '"'):lines() do
    if file ~= '.' and file ~= '..' and file ~= '.git' then
      coroutine.yield(file)
    end
  end
end

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
  -- o.type = vim.api.nvim_buf_get_option(0, 'filetype')

  o.split = function() return str.split(path, '/') end
  o.parent = function() return Path:new(vim.fn.fnamemodify(path, ':h')) end

  o.is_dir = function() return vim.fn.isdirectory(path) == 1 end
  o.is_file = function() return vim.fn.filereadable(path) == 1 end
  o.exists = function() return o.is_dir() or o.is_file() end

  o.iterdir = function()
    if not o.is_dir() then
      error('Cannot iterate a file: ' .. path)
    end

    local co = coroutine.create(function() iterdir(path) end)
    return function()
      local _, value = coroutine.resume(co)
      if value ~= nil then
        return Path:new(path .. '/' .. value)
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

local d = Path:new('/Users/j0rdi/.config/nvim')

-- iter dir
for n in d.iterdir() do
  P(n)
end
--
local f = Path:new('/Users/j0rdi/.config/nvim/test.lua')

return Path
