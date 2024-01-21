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
  if node.is_file() and node.ext == '.py' then
    print(node.abs)
  end
end

--[[ f.append({
  'print("Hello, world!")',
  'print("Hello, world2!")',
})

for i, line in f.iterlines() do
  print(i + 1, line)
end ]]

--[[ print('READ', f.read())

print(f.exec('python3')) ]]

--[[ if f.exists() then
  f.unlink()
end ]]
