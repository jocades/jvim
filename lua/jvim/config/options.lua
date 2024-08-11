vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

local opts = {
  clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  mouse = 'a', -- enable mouse mode
  incsearch = true, -- highlit while search
  hlsearch = false, -- highlight on search
  number = true, -- make line numbers default
  rnu = false, -- set relative line numbers
  wrap = true,
  linebreak = true,
  shiftround = true, -- Round indent
  shiftwidth = 2, -- Size of an indent
  smartindent = true, -- make indenting smarter again
  equalalways = false, -- make windows always equal height
  confirm = true, -- Confirm to save changes before exiting modified buffer
  expandtab = true, -- Use spaces instead of tabs
  tabstop = 2, -- Number of spaces tabs count for
  inccommand = 'nosplit', -- preview incremental substitute
  laststatus = 3, -- global status line
  list = true, -- Show some invisible characters (tabs...
  sessionoptions = {
    'buffers',
    'curdir',
    'tabpages',
    'winsize',
    'help',
    'globals',
    'skiprtp',
    'folds',
  },
  sidescrolloff = 8, -- Columns of context
  scrolloff = 6, -- always n lines below the cursor
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
  cmdheight = 1, -- more space in the neovim command line for displaying messages
  pumheight = 10, -- pop up menu height
  completeopt = { 'menuone', 'noselect' }, -- set completeopt to have a better completion experience
  fillchars = { eob = '~' },
  showmode = false,
  colorcolumn = '80', -- Line length marker (ruler)
}

-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.opt.foldtext = ''

for k, v in pairs(opts) do
  vim.opt[k] = v
end

vim.o.formatoptions = 'jqlnt' -- dont add comment on new line
vim.opt.smoothscroll = true

-- File types (maybe use dedicated module)
vim.filetype.add({
  extension = {
    es = 'es',
    mdx = 'markdown',
    astro = 'astro',
  },
})

vim.treesitter.language.register('markdown', 'mdx')
