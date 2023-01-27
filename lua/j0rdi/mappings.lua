-- See `:help vim.keymap.set()`
local function map(mode, keys, exec, opts)
  local common = { silent = true, noremap = true }

  if not opts then
    opts = common
  else
    vim.tbl_extend('force', opts, common)
  end

  vim.keymap.set(mode, keys, exec, opts)
end

-- Set <SPACE> as the 'LEADER' key, see `:help mapleader` (must happen before plugins are required)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
map({ 'n', 'v' }, '<Space>', '<Nop>')

local cmd = vim.cmd

local K = {

  -- NORMAL
  n = {
    -- Open file trees
    ['<leader>e'] = { cmd.NvimTreeToggle, { desc = 'Toggle nvim-tree' } },
    ['<leader>n'] = { cmd.Ex, { desc = 'Open netrw' } }, -- ':Lex 20 <CR>'

    -- Save / Close buffer
    ['<C-s>'] = { cmd.w, { desc = 'Save buffer' } },
    ['<leader>x'] = { cmd.bd, { desc = 'Close buffer' } },

    -- Exit (quit all including nvim-tree)
    ['<leader>Q'] = { cmd.qall, { desc = 'Quit all (nvim-tree)' } },

    -- Window navigation
    ['<C-h>'] = { '<C-w>h' },
    ['<C-l>'] = { '<C-w>l' },
    ['<C-j>'] = { '<C-w>j' },
    ['<C-k>'] = { '<C-w>k' },

    -- Buffer navigation
    ['<Tab>'] = { cmd.bnext },
    ['<S-Tab>'] = { cmd.bprev },

    -- Split / Close windows
    ['<leader>ss'] = { cmd.vsplit, { desc = 'Vertical split' } },
    ['<leader>sh'] = { cmd.split, { desc = 'Horizontal split' } },
    ['<leader>ww'] = { cmd.close, { nowait = true, desc = 'Close window' } },

    -- Resize windows with arrows
    ['<C-Up>'] = { ':resize +2 <cr>' },
    ['<C-Down>'] = { ':resize -2 <cr>' },
    ['<C-Left>'] = { ':vertical resize -2 <cr>' },
    ['<C-Right>'] = { ':vertical resize +2 <cr>' },

    -- Insert blank line on top / bottom of the cursor
    ['<CR>'] = { 'o<ESC>' },
    ['<S-CR>'] = { 'O<ESC>' },

    -- Keep cursor centered when scrolling
    ['<C-d>'] = { '<C-d>zz' },
    ['<C-u>'] = { '<C-u>zz' },

    -- Navigate within wrapped lines
    -- ['k'] = { "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
    -- ['j'] = { "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },
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

for mode, keymaps in pairs(K) do
  for keys, t in pairs(keymaps) do
    map(mode, keys, t[1], t[2])
  end
end
