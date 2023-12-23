-- OOP in lua

---@class User
---@field name string
---@field age number
local User = {}

---@param o User
function User:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

local user = User:new({ name = 'John', age = 20, id = 1 })
