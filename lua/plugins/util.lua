return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
    end,
  },

  'nvim-lua/plenary.nvim',
  { 'moll/vim-bbye', event = 'VeryLazy' }, -- better buffer deletion
  'tpope/vim-sleuth', -- detect tabstop and shiftwidth automatically
  'github/copilot.vim',
  --'p00f/nvim-ts-rainbow', -- colored parenthesis
  { 'iamcco/markdown-preview.nvim', build = 'cd app && yarn install', cmd = 'MarkdownPreview' }, -- markdown preview

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup {}
    end,
  },
}
