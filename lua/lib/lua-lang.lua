-- Classes in lua https://www.lua.org/pil/16.1.html

-- Account class to be used in the bank

Account = { balance = 0 }

function Account:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Account:deposit(v) self.balance = self.balance + v end

local account = Account:new { balance = 0 }

account:deposit(100.00)

print(account.balance)
