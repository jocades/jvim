-- GOAL:
-- local Person = class()
-- function Person:new(name) self.name = name end
-- function Persion:greet() print('Hello, my name is ' .. self.name) end
--
-- local Student = class(Person)
-- local s = Student('Jordi')
-- s:greet()

local function class(...)
  local cls, bases = {}, { ... }
  -- copy base class contents into the new class
  for _, base in ipairs(bases) do
    for k, v in pairs(base) do
      cls[k] = v
    end
  end

  -- set the class's __index, and start filling an "is_a" table that contains this class and all of its bases
  -- so you can do an "instance of" check using my_instance.is[MyClass]
  cls.__index, cls.is = cls, { [cls] = true }
  for _, base in ipairs(bases) do
    for c in pairs(base.is) do
      cls.is[c] = true
    end
    cls.is[base] = true
  end

  -- the class's __call metamethod
  setmetatable(cls, {
    __call = function(c, ...)
      local self = setmetatable({}, c)
      self:new(...)
      return self
    end,
  })

  return cls
end

local Person = class()

function Person:new(name) self.name = name end

function Person:greet() print('Hello, my name is ' .. self.name) end

local Student = class(Person)

local p = Person('Jordi')

p:greet()

local s = Student('Maria')

--[[ local function class(base)
  local c = {}
  c.__index = c
  c._base = base
  setmetatable(c, {
    __call = function(_, ...)
      local self = setmetatable({}, c)
      self:new(...)
      return self
    end,
  })
  return c
end ]]
