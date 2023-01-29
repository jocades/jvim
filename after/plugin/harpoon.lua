local mark = require 'harpoon.mark'
local ui = require 'harpoon.ui'

local K = {
  ['<leader>a'] = { mark.add_file, { desc = 'Add file to harpoon' } },
  ['<M-h>'] = { ui.toggle_quick_menu },
  ['<M-j>'] = { function() ui.nav_file(1) end },
  ['<M-k>'] = { function() ui.nav_file(2) end },
  ['<M-l>'] = { function() ui.nav_file(3) end },
  ['<M-;>'] = { function() ui.nav_file(4) end },
}

for k, v in pairs(K) do
  require('j0rdi.utils').map('n', k, v[1], v[2])
end
