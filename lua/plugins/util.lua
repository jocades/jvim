return {

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',
  'github/copilot.vim',

  'moll/vim-bbye', -- better buffer deletion
  'tpope/vim-sleuth', -- detect tabstop and shiftwidth automatically
  'folke/zen-mode.nvim',
  'akinsho/toggleterm.nvim',
  --'p00f/nvim-ts-rainbow', -- colored parenthesis
  { 'iamcco/markdown-preview.nvim', build = 'cd app && yarn install', cmd = 'MarkdownPreview' }, -- markdown preview

  {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup {}
    end,
  },
}
