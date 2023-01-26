local say_hello = function()
  print 'Hello from local function'
end

print 'Hello from file'

-- return function()
--   print 'Hello from module function'
-- end
--
local M = {}

M.json = 'hello'

return M

-- return {
--   greet = say_hello,
--   str = 'Im just a string',
-- }
