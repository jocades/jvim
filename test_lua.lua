local M = {}

-- vim.keymap.set('i', 'jk', '<ESC>', { nowait = true })

local function set_keymap(table)
  for mode, v in table do
    print(mode,v[1])
  end
end


M = {
  i = { 'jk', '<ESC>', { nowait = true } },
  n = { 'C-s', '<cmd> w <CR>' }
}


for k, v in ipairs(M.i) do
  print(k,v)
end


for k, v in pairs(M) do
  print (k,v)
end

local list = { 'a', 'b', 'c' }

for i, v in ipairs(list) do
  print(i, v)
end








