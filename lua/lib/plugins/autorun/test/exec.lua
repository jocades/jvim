local User = {
  new = function(self, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
  end,

  __tostring = function(self) return 'Hello, my name is ' .. self.name .. ' and I am ' .. self.age .. ' years old' end,

  inc_age = function(self) self.age = self.age + 1 end,
}

function User:dec_age() self.age = self.age - 1 end

local user = User:new({ name = 'John', age = 20 })

print(user)
user:inc_age()
print(user)
user:dec_age()
print(user)

user:dec_age()
user:dec_age()
print(user)
