-- Set <SPACE> as the '<LEADER>' key, see `:help mapleader` (must happen before plugins are required)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local cmd = vim.cmd
local new_buf = require('j0rdi.utils').handle_new_buf

local K = {
  -- NORMAL
  n = {
    -- Common
    ['<leader>e'] = { cmd.NvimTreeToggle, { desc = 'Toggle nvim-tree' } },
    ['<leader>q'] = { cmd.qall, { desc = 'Quit all' } },
    ['<leader>Q'] = { ':qall!<cr>', { desc = 'Quit no save' } },

    -- Buffer actions
    ['<C-s>'] = { cmd.w, { desc = 'Save buffer' } },
    ['<leader>so'] = { ':so %<cr>', { desc = 'Source & exec current config file' } },
    ['<leader>x'] = { cmd.bd, { desc = 'Close buffer', nowait = true } },
    ['<leader>X'] = { ':bd!<cr>', { desc = 'Close buffer without saving' } },
    ['<leader>nf'] = { new_buf, { desc = 'Create new file in current dir', nowait = true } },
    ['<leader>ns'] = { function() new_buf { type = 'v' } end, { desc = 'Create new vertical split' } },
    ['<leader>nh'] = { function() new_buf { type = 'h' } end, { desc = 'Create new horizontal split' } },

    -- Buffer navigation
    ['<Tab>'] = { cmd.bnext },
    ['<S-Tab>'] = { cmd.bprev },

    -- Window actions
    ['<leader>ss'] = { cmd.vsplit, { desc = 'Vertical split' } },
    ['<leader>sh'] = { cmd.split, { desc = 'Horizontal split' } },
    ['<leader>ww'] = { cmd.close, { desc = 'Close window' } },

    -- Window navigation
    ['<C-h>'] = { '<C-w>h' },
    ['<C-l>'] = { '<C-w>l' },
    ['<C-j>'] = { '<C-w>j' },
    ['<C-k>'] = { '<C-w>k' },

    -- Resize windows with arrows
    ['<C-Up>'] = { ':resize +2<cr>' },
    ['<C-Down>'] = { ':resize -2<cr>' },
    ['<C-Left>'] = { ':vertical resize -2<cr>' },
    ['<C-Right>'] = { ':vertical resize +2<cr>' },

    -- Insert blank line on top / bottom of the cursor
    ['<C-cr>'] = { 'o<ESC>' },
    ['<S-cr>'] = { 'O<ESC>' },

    -- Keep cursor centered when scrolling
    ['<C-d>'] = { '<C-d>zz' },
    ['<C-u>'] = { '<C-u>zz' },

    -- Diagnostics
    ['[d'] = { vim.diagnostic.goto_prev },
    [']d'] = { vim.diagnostic.goto_next },
    ['<leader>f'] = { vim.diagnostic.open_float },
    ['<leader>dl'] = { vim.diagnostic.setloclist, { desc = 'Show diagnostics in quickfix' } },
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

function Flex()
  local friend_name = vim.fn.input 'Who are we flexing on?: '
  friend_name = friend_name:gsub('^%l', string.upper)
  local msg = string.format(" %s... Jordi's config is on another level! He wrote it in Lua! ", friend_name)
  vim.notify(msg, vim.log.levels.WARN, { title = 'Flex' })
end
