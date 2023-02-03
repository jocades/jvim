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
  equalalways = true, -- make windows always equal height

  scrolloff = 10, -- always 10 lines below the cursor
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
}

vim.opt.winbar = '%=%m %f'

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

-- Cursorline control
-- local group = vim.api.nvim_create_augroup('CursorLineControl', { clear = true })
-- local function set_cursorline(event, value, pattern)
--   vim.api.nvim_create_autocmd(event, {
--     group = group,
--     pattern = pattern,
--     callback = function() vim.opt_local.cursorline = value end,
--   })
-- end
-- set_cursorline('WinLeave', false)
-- set_cursorline('WinEnter', true)
-- set_cursorline('FileType', false, 'TelescopePrompt')
