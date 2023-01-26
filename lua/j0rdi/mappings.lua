-- See `:help vim.keymap.set()`
local map = vim.keymap.set
local cmd = vim.cmd
local opts = { noremap = true, silent = true }

-- Set <space> as the leader key, see `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Open file trees (netrw, nvim-tree)
map('n', '<leader>n', cmd.Explore, opts) -- 'Lex 20 <CR>'
map('n', '<leader>e', ':NvimTreeToggle <CR>', opts)

-- Save / Close buffer
map('n', '<C-s>', cmd.w, opts)
map('n', '<leader>x', cmd.bd, opts)

-- Navigate between windows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')

-- Resize with arrows
map('n', '<C-Up>', ':resize +2 <CR>', opts)
map('n', '<C-Down>', ':resize -2 <CR>', opts)
map('n', '<C-Left>', ':vertical resize -2 <CR>', opts)
map('n', '<C-Right>', ':vertical resize +2 <CR>', opts)

-- Buffer navigation
map('n', '<Tab>', cmd.bnext)
map('n', '<S-Tab>', cmd.bprevious)

-- Split / Close windows
map('n', '<leader>s', cmd.vsplit, opts)
map('n', '<leader>sh', cmd.split, opts)
map('n', '<leader>w', '<C-w>q', opts)

-- Navigate in wrapped lines
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Exit insert mode
map('i', 'jk', '<ESC>', { nowait = true })

-- Navigate within insert mode
map('i', '<C-h>', '<Left>')
map('i', '<C-l>', '<Right>')
map('i', '<C-j>', '<Down>')
map('i', '<C-k>', '<Up>')

-- Move selected block
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Stay in indent mode
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)
