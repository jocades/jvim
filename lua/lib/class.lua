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

return class
