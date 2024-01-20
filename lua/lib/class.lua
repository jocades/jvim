local function class(...)
  local cls, bases = {}, { ... }

  for _, base in ipairs(bases) do
    for k, v in pairs(base) do
      cls[k] = v
    end
  end

  cls.__index, cls.lookup = cls, { [cls] = true }

  for _, base in ipairs(bases) do
    for c in pairs(base.lookup) do
      cls.lookup[c] = true
    end
    cls.lookup[base] = true
  end

  cls.is = function(self, other) return not not self.lookup[other] end

  setmetatable(cls, {
    __call = function(c, ...)
      local self = setmetatable({}, c)
      self:new(...)
      return self
    end,
  })

  return cls
end

--[[ ---@class Person
---@field name string
---@field age number
---@field greet fun(): nil
---@overload fun(init: { name: string, age: number }): Person
local Person = class()

function Person:new(init)
  self.name = init.name
  self.age = init.age
end

function Person:greet() print(string.format('Hello, my name is %s and I am %d years old', self.name, self.age)) end

local Student = class(Person)

local p = Person({ name = 'Jordi', age = 30 })

-- p:greet()

local s = Student({ name = 'Maria', age = 10 })

-- s:greet() ]]

return class
