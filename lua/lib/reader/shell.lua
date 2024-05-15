-- read from stdin and print
-- $ python main.py | lua shell.lua

while true do
  local line = io.read()
  if line == nil then break end
  print('lua -> ' .. line)
end
