local kmap = function(mode, keys, command, opts)
  vim.keymap.set(mode, keys, command, opts)
end

-- Set <space> as the leader key, see `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymaps for better default experience, see `:help vim.keymap.set()`
kmap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Open netrw (default nvim tree)
kmap("n", "<leader>e", vim.cmd.Ex)

-- Exit insert mode
kmap("i", "jk", "<ESC>", { nowait = true })

-- Save buffer
kmap("n", "<C-s>", vim.cmd.w)

-- Close buffer
kmap("n", "<leader>x", "<cmd> bd <CR>")

-- Tab navigation
kmap("n", "<Tab>", "<cmd> bnext <CR>")
kmap("n", "<S-Tab>", "<cmd> bprevious <CR>")

-- Navigate within insert mode
kmap("i", "<C-h>", "<Left>")
kmap("i", "<C-l>", "<Right>")
kmap("i", "<C-j>", "<Down>")
kmap("i", "<C-k>", "<Up>")

-- Navigate between windows
kmap("n", "<C-h>", "<C-w>h")
kmap("n", "<C-l>", "<C-w>l")
kmap("n", "<C-j>", "<C-w>j")
kmap("n", "<C-k>", "<C-w>k")

-- Navigate in wrapped lines
kmap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
kmap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
