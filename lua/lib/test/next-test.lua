local Path = require('lib.path')

local input = 'hello/world'

local x = Path(input)

if #x.parts > 1 then
  P(x.parts)
end
