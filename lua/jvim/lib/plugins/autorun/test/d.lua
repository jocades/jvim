local t = { 'bun', 'run' }

local y = { name = 'bun', age = 10, add = { x = 1, y = 2 } }
local x = table.deepcopy(y)

x.name = 'run'

table.inspect(x)
