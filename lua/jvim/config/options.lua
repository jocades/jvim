vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
-- mini.animate will also be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

local opts = {
  clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  mouse = 'a', -- enable mouse mode
  incsearch = true, -- highlit while search
  hlsearch = false, -- highlight on search
  swapfile = false,
  number = true, -- make line numbers default
  rnu = false, -- set relative line numbers
  wrap = false,
  --  smartindent = true, -- make indenting smarter again
  equalalways = false, -- make windows always equal height

  expandtab = true, -- Use spaces instead of tabs
  formatoptions = 'jcroqlnt', -- tcqj
  grepformat = '%f:%l:%c:%m',
  grepprg = 'rg --vimgrep',
  inccommand = 'nosplit', -- preview incremental substitute
  laststatus = 0,
  --list = true, -- Show some invisible characters (tabs...
  --pumblend = 10, -- Popup blend
  sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' },
  shiftround = true, -- Round indent
  --shiftwidth = 2, -- Size of an indent
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
  --winbar = '%=%m %f',
  colorcolumn = '80', -- Line length marker (ruler)
}

if vim.fn.has('nvim-0.10') == 1 then
  print('v0.10')
  vim.opt.smoothscroll = true
  vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  vim.opt.foldmethod = 'expr'
  vim.opt.foldtext = ''
else
  vim.opt.foldmethod = 'indent'
  vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

for k, v in pairs(opts) do
  vim.opt[k] = v
end

-- file types (maybe use dedicated module)
vim.filetype.add({
  extension = {
    es = 'es',
  },
})

vim.filetype.add({
  extension = {
    mdx = 'markdown',
  },
})

vim.treesitter.language.register('markdown', 'mdx')

vim.filetype.add({
  extension = {
    astro = 'astro',
  },
})
