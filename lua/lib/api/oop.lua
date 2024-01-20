-- lua does not have a built-in oop system, but we can use the concept of metatables and prototypes to create one

-- create namespace
local Window = {}
-- create the prototype with default values
Window.prototype = { width = 0, height = 0, x = 0, y = 0 }

-- create a metatable
Window.mt = {}

-- declare the constructor function
function Window.new(o)
  setmetatable(o, Window.mt)
  return o
end

-- now define the __index metamethod
Window.mt.__index = function(table, key) return Window.prototype[key] end

-- create a new window
