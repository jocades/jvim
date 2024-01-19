-- trying to implement pythons pathlib in lua

-- goal:
-- local p = Path('/Users/j0rdi/.config/nvim')
-- p.mkdir()
-- for file in p.iterdir() do ...
-- p / 'lua' / 'path.lua'
-- ...

-- first of how to call the class directly like in python?
-- Path('/Users/j0rdi/.config/nvim')

-- make a base class which __call metamethod returns the Path class

local function class(base)
  local c = {}
  c.__index = c
  c.base = base
  setmetatable(c, {
    __call = function(cls, ...)
      local self = setmetatable({}, c)
      self:new(...)
      return self
    end,
  })
  return c
end

local Path = class()

function Path:new(path) self.path = path end

function Path:__tostring() return self.path end

local p = Path('/Users/j0rdi/.config/nvim')
P(p.path)
