local Class = {
  new = function(self, name)
    local obj = {
      name = name,
    }

    setmetatable(obj, self)
    self.__index = self

    return obj
  end,

  fn1 = function(self) print(self.name) end,

  fn = function(_, n) print(n) end,
}

local instance = Class:new 'Jordi'
instance:fn(10)
instance:fn1()
instance.fn1(instance)

Class.fn3 = function(self) print(self.name) end

instance:fn3()

local object = {
  field = 'Jordi',
  method = function(self, a, b, c)
    print(a, b, c)
    print(self.field)
  end,
}

object:method(unpack { 'j', 'k', 'l' })

local function multiple_returns() return 'string', 10 end

local r1, r2 = multiple_returns()

print(r1, r2)

-- Another syntax
local Class1 = {}

function Class1:new(name)
  local obj = {
    name = name,
  }

  setmetatable(obj, self)
  self.__index = self

  return obj
end

function Class1:fn(n) print(n) end

function Class1:fn1() print(self.name) end

local obj = Class1:new 'Jordi'
obj:fn(10)
obj:fn1()

Class1.fn3 = function(self) print(self.name) end

obj:fn3()
