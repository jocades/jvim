local Path = require('lib.path')

local p = Path.cwd()

local f = p / 'test.py'

if not f.exists() then
  f.write({
    'import sys',
    'print("Version:", sys.version)',
    'print("Argv:", sys.argv)',
  })
end

for node in p.iterdir() do
  if node.is_file() and node.ext == 'py' then
    print(node)
  end
end

for i, line in f.lines() do
  print(i, line)
end

f.unlink()
