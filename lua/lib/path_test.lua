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
    __call = function(_, ...)
      local self = setmetatable({}, c)
      self:new(...)
      return self
    end,
  })
  return c
end

---@class P
---@field path string
---@field base P
---@field join fun(self: P, ...: string | P): P
---@field __tostring fun(self: P): string
---@field __div fun(self: P, other: P | string): P
---@field is_path fun(o: any): boolean
---@field __index P
---@field __call fun(self: P, path: string): P
---@field new fun(self: P, path: string): P

---@class P
local Path = class()

-- how to create inheritance?

function Path:new(path) self.path = path end

function Path.__tostring(self) return self.path end

function Path:join(...)
  assert(Path.is_path(self))

  local args = { ... }
  for i, v in ipairs(args) do
    assert(Path.is_path(v) or type(v) == 'string')
    args[i] = tostring(v)
  end

  return Path(self.path .. '/' .. table.concat(args, '/'))
end

function Path.is_path(o) return getmetatable(o) == Path end

function Path.__div(self, other) return self:join(other) end

local p = Path('/Users/j0rdi/.config/nvim')
local n = Path('lua')

local y = p / n / 'path.lua'
print(y)
local z = p:join(n, 'path.lua')
print(z)
