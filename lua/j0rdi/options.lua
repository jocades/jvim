-- See `:help vim.o`

local options = {
  fillchars = { eob = '~' }, -- end of file fill (not working I think its cus of the colorscheme)
  --clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  mouse = 'a', -- enable mouse mode
  incsearch = true, -- highlit while search
  hlsearch = false, -- highlight on search
  swapfile = false,
  number = true, -- make line numbers default
  rnu = false, -- set relative line numbers
  wrap = false,
  --  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  cursorline = true, -- highlight current line
  breakindent = true, -- enable break indent
  undofile = true, -- save undo history
  ignorecase = true, -- case insensitive searching UNLESS /C or capital in search
  smartcase = true,
  updatetime = 250, -- decrease update time
  signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time
  termguicolors = true, -- set colorscheme
  cmdheight = 2, -- more space in the neovim command line for displaying messages
  pumheight = 10, -- pop up menu height
  completeopt = { 'menuone', 'noselect' }, -- set completeopt to have a better completion experience
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

--  Highlight on yank, see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = '*',
})
