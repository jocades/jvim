local map = function(mode, keys, command, opts)
  vim.keymap.set(mode, keys, command, opts)
end

-- Set <space> as the leader key, see `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local cmd = vim.cmd

-- Keymaps for better default experience, see `:help vim.keymap.set()`
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.opt.fillchars = { eob = "~" }
-- Open netrw (default nvim tree)
map("n", "<leader>e", cmd.Ex)

-- Exit insert mode
map("i", "jk", "<ESC>", { nowait = true })

-- Save buffer
map("n", "<C-s>", cmd.w)

-- Close buffer
map("n", "<leader>x", cmd.bd)

-- Tab navigation
map("n", "<Tab>", cmd.bnext)
map("n", "<S-Tab>", cmd.bprevious)

-- Navigate within insert mode
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

-- Navigate between windows
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- Move selected block
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Navigate in wrapped lines
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
