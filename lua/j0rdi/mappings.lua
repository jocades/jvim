-- See `:help vim.keymap.set()`

local function nmap(mode, keys, exec, opts)
  if not opts then
    opts = { noremap = true, silent = true }
  end

  vim.keymap.set(mode, keys, exec, opts)
end

-- Set <space> as the leader key, see `:help mapleader`
-- Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
nmap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local cmd = vim.cmd

local K = {
  -- Normal mode
  n = {
    -- Open file trees (netrw, nvim-tree)
    ['<leader>n'] = { cmd.Explore }, -- ':Lex 20 <CR>'
    ['<leader>e'] = { cmd.NvimTreeToggle },

    -- Save / Close buffer
    ['<C-s>'] = { cmd.w },
    ['<leader>x'] = { cmd.bd },
  },
}

for mode, keymap in pairs(K) do
  for keys, table in pairs(keymap) do
    nmap(mode, keys, table[1], table[2])
    -- print(mode, keys, table[1], table[2])
  end
end

-- map('n', '<leader>n', cmd.Explore)
--map('n', '<leader>e', cmd.NvimTreeToggle)

-- Navigate between windows
nmap('n', '<C-h>', '<C-w>h')
nmap('n', '<C-l>', '<C-w>l')
nmap('n', '<C-j>', '<C-w>j')
nmap('n', '<C-k>', '<C-w>k')

-- Resize with arrows
nmap('n', '<C-Up>', ':resize +2 <CR>')
nmap('n', '<C-Down>', ':resize -2 <CR>')
nmap('n', '<C-Left>', ':vertical resize -2 <CR>')
nmap('n', '<C-Right>', ':vertical resize +2 <CR>')

-- Buffer navigation
nmap('n', '<Tab>', cmd.bnext)
nmap('n', '<S-Tab>', cmd.bprevious)

-- Split / Close windows
nmap('n', '<leader>s', cmd.vsplit)
nmap('n', '<leader>sh', cmd.split)
nmap('n', '<leader>w', '<C-w>q')

-- Navigate in wrapped lines
nmap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
nmap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Exit insert mode
nmap('i', 'jk', '<ESC>', { nowait = true })

-- Navigate within insert mode
nmap('i', '<C-h>', '<Left>')
nmap('i', '<C-l>', '<Right>')
nmap('i', '<C-j>', '<Down>')
nmap('i', '<C-k>', '<Up>')

-- Move selected block
nmap('v', 'J', ":m '>+1<CR>gv=gv")
nmap('v', 'K', ":m '<-2<CR>gv=gv")

-- Stay in indent mode
nmap('v', '<', '<gv')
nmap('v', '>', '>gv')
