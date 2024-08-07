-- See `:help vim.o`

local options = {
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

for k, v in pairs(options) do
  vim.opt[k] = v
end
