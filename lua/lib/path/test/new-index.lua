local Base = {
  __type = 'Base',
  __call = function(c, ...)
    local self = setmetatable({}, c)
    self:new(...)
    return self
  end,
}

--- Metatable
function Base.__index(self, key) return self[key] end

function Base.__newindex(self, key, value)
  if key == 'foo' then
    error('Cannot set foo')
  end

  rawset(self, key, value)
end

--- Class
function Base:new() print('Base.new()') end

-- local b = Base.new()
local b = Base()

-- b.foo = 'bar'
b.bar = 'foo'

print(b.bar)
