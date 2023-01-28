-- If the function includes a self argument, it is a method. If it does not, it is a function.
-- To call a method = obj:method()
local Obj = {
  new = function(self, name)
    local obj = {
      name = name,
    }

    setmetatable(obj, self)
    self.__index = self

    return obj
  end,

  fn1 = function(self)
    print(self.name)
  end,

  fn = function(_, n)
    print(n)
  end,
}

local obj = Obj:new 'Jordi'
obj:fn(10)
obj:fn1()
obj.fn1(obj)

Obj.fn3 = function(self)
  print(self.name)
end

obj:fn3()

local class = {
  field = 'Jordi',
  method = function(self, a, b, c)
    print(a, b, c)
    print(self.field)
  end,
}

class:method(unpack { 'j', 'k', 'l' })

local function multiple_returns()
  return 'string', 10
end

local r1, r2 = multiple_returns()

print(r1, r2)

-- Another syntax
local Class = {}

function Class:new(name)
  local obj = {
    name = name,
  }

  setmetatable(obj, self)
  self.__index = self

  return obj
end

function Class:fn(n)
  print(n)
end

function Class:fn1()
  print(self.name)
end

local instance = Class:new 'Jordi'
instance:fn(10)
instance:fn1()

Class.fn3 = function(self)
  print(self.name)
end

instance:fn3()
