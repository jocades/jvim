local Path = require('lib.path')

local cwd = Path.cwd()

local f = cwd / 'test.py'

if not f.exists() then
  f.write({
    'import sys',
    'print("Version:", sys.version)',
    'print("Argv:", sys.argv)',
  })
end

for node in cwd.iterdir() do
  if node.is_file() and node.ext == 'py' then
    -- P(node)
    print(node)
  end
end

print(f.exec('python3'))

for i, line in f.lines({ enumerate = true }) do
  print(i, line)
end

f.unlink();

(cwd / 'touch.txt').touch()

if (cwd / 'touch.txt').exists() then
  local dir = (cwd / 'touch.txt').parent()
  P(dir.parts);
  (cwd / 'touch.txt').unlink()
end
