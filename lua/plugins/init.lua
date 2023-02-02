require 'config.options'
require 'config.mappings'

return {

  'folke/zen-mode.nvim', -- distraction free writing

  -- Snippets
  'L3MON4D3/LuaSnip', -- snippet engine
  'rafamadriz/friendly-snippets', -- a bunch of snippets to use

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',

  -- Copilot
  'github/copilot.vim',

  -- Terminal
  'akinsho/toggleterm.nvim',

  'kyazdani42/nvim-web-devicons', -- required by many other plugins
  -- Snazzy statusline, bufferline & file tree
  --'nvim-lualine/lualine.nvim',
  --'kyazdani42/nvim-tree.lua',
  --'akinsho/bufferline.nvim',

  -- Custom home screen
  -- 'goolord/alpha-nvim',

  { -- Keys helper
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup {}
    end,
  },

  { 'NvChad/nvim-colorizer.lua', config = true }, -- color highlighter
  -- Misc --
  'moll/vim-bbye', -- better buffer deletion
  'lukas-reineke/indent-blankline.nvim', -- add indentation guides even on blank lines
  'tpope/vim-sleuth', -- detect tabstop and shiftwidth automatically
  'lewis6991/impatient.nvim', -- speed up startup time
  --'p00f/nvim-ts-rainbow', -- colored parenthesis
  { 'iamcco/markdown-preview.nvim', build = 'cd app && yarn install', cmd = 'MarkdownPreview' }, -- markdown preview
}