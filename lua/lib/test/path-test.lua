local Path = require('lib.path')

local p = Path.cwd() / 'test.py'

-- p.write({
--   'import sys',
--   'print("Version:", sys.version)',
--   'print("Argv:", sys.argv)',
-- })
--
-- -- print(p.exec('python3'))
--
-- p.append('print("Hello, World!")')
--
-- print(p.exec('python3'))

-- print(p.read())

for node in (Path.home() / 'dev' / 'dotfiles').iterdir() do
  print(node)
end
