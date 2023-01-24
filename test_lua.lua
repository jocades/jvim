local M = {}

-- vim.keymap.set('i', 'jk', '<ESC>', { nowait = true })

M = {
  i = { 'jk', '<ESC>', { nowait = true } },
  n = { 'C-s', '<cmd> w <CR>' }
}

for mode, settings in pairs(M) do
  for _, setting in ipairs(settings) do
    print(setting)
  end
end

local list = { 'a', 'b', 'c' }

for _, v in ipairs(list) do
  print(v)
end










