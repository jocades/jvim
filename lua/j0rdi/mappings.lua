local cmd = vim.cmd
local new_buf = require('j0rdi.utils').handle_new_buf

-- Set <SPACE> as the '<LEADER>' key, see `:help mapleader` (must happen before plugins are required)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local K = {
  -- NORMAL
  n = {
    -- Common
    ['<leader>e'] = { cmd.NvimTreeToggle, { desc = 'Toggle nvim-tree' } },
    ['<leader>q'] = { cmd.qall, { desc = 'Quit all' } },
    ['<leader>Q'] = { ':qall!<cr>', { desc = 'Quit no save' } },

    -- Buffer actions
    ['<C-s>'] = { cmd.w, { desc = 'Save buffer' } },
    ['<leader>x'] = { cmd.bd, { desc = 'Close buffer', nowait = true } },
    ['<leader>X'] = { ':bd!<cr>', { desc = 'Close buffer without saving' } },
    ['<leader>nf'] = { new_buf, { desc = 'Create new file in current dir', nowait = true } },
    ['<leader>ns'] = { function() new_buf { type = 'v' } end, { desc = 'Create new vertical split' } },
    ['<leader>nh'] = { function() new_buf { type = 'h' } end, { desc = 'Create new horizontal split' } },
    ['<leader>so'] = { ':w | so %<cr>', { desc = 'Save, source & run current config file' } },

    -- Buffer navigation (harpoon for buf navigation and organization)
    ['<Tab>'] = { cmd.bnext },
    ['<S-Tab>'] = { cmd.bprev },

    -- Window actions
    ['<leader>ss'] = { cmd.vsplit, { desc = 'Vertical split' } },
    ['<leader>sh'] = { cmd.split, { desc = 'Horizontal split' } },
    ['<leader>z'] = { cmd.close, { desc = 'Close window' } },
    ['<C-Up>'] = { ':resize +2<cr>' },
    ['<C-Down>'] = { ':resize -2<cr>' },
    ['<C-Left>'] = { ':vertical resize -2<cr>' },
    ['<C-Right>'] = { ':vertical resize +2<cr>' },

    -- Window navigation
    ['<C-h>'] = { '<C-w>h' },
    ['<C-l>'] = { '<C-w>l' },
    ['<C-j>'] = { '<C-w>j' },
    ['<C-k>'] = { '<C-w>k' },

    -- Diagnostics
    ['[d'] = { vim.diagnostic.goto_prev },
    [']d'] = { vim.diagnostic.goto_next },
    ['<leader>f'] = { vim.diagnostic.open_float },
    ['<leader>dl'] = { vim.diagnostic.setloclist, { desc = 'Show diagnostics in quickfix' } },

    -- Insert blank line on top / bottom of the cursor
    ['<C-cr>'] = { 'o<ESC>' },
    ['<S-cr>'] = { 'O<ESC>' },

    -- Keep cursor centered when scrolling
    ['<C-d>'] = { '<C-d>zz' },
    ['<C-u>'] = { '<C-u>zz' },
  },

  -- INSERT
  i = {
    -- Exit insert mode
    ['jk'] = { '<ESC>', { nowait = true } },

    -- Navigate horizontally
    ['<C-h>'] = { '<Left>' },
    ['<C-l>'] = { '<Right>' },
  },

  -- VISUAL
  v = {
    -- Move selected block
    ['J'] = { ":m '>+1<CR>gv=gv" },
    ['K'] = { ":m '<-2<CR>gv=gv" },

    -- Stay in indent mode
    ['<'] = { '<gv' },
    ['>'] = { '>gv' },
  },
}

-- DRY
for mode, keymaps in pairs(K) do
  for keys, t in pairs(keymaps) do
    require('j0rdi.utils').map(mode, keys, t[1], t[2])
  end
end
