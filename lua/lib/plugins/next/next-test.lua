local Path = require('lib.path')

local input = 'test/hello'

local x = Path(input)

if not x.ext then
  x = Path(input .. '.tsx')
end

local r = Path('lua/lib/src/app')
local f = r / x.name

print(f)
