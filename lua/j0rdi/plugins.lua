-- Auto install packer on bootsrap
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }

  print 'Installing packer. Close and reopen neovim.'

  vim.cmd [[packadd packer.nvim]]
end

-- Automatically source and re-compile packer on save
-- local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
--
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   command = 'plugins.lua source <afile> | PackerSync',
--   group = packer_group,
--   pattern = vim.fn.expand '$MYVIMRC',
-- })

-- Auto compile when savaing this file.
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

-- Protected call, no error out on first use
local present, packer = pcall(require, 'packer')

if not present then
  return print 'Error: Packer not installed...'
end

packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

-- PLUGINS
return packer.startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- LSP Configuration & Plugins
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim', -- automatically install LSPs to stdpath for neovim
      'williamboman/mason-lspconfig.nvim', -- lspconfig setup (capabilites, on_attach...)
      'j-hui/fidget.nvim', -- useful status updates for LP
      'folke/neodev.nvim', -- additional lua configuration, makes nvim stuff amazing
      'jose-elias-alvarez/null-ls.nvim', -- attaches to an LSP and allows formatting, additional linting, etc.
    },
  }

  -- Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp', -- lsp completion
      'hrsh7th/cmp-buffer', -- buffer completion
      'hrsh7th/cmp-cmdline', -- cmdline completion
      'saadparwaiz1/cmp_luasnip', -- snippet completion
      'hrsh7th/cmp-path', -- path completion
    },
  }

  -- Snippets
  use 'L3MON4D3/LuaSnip' -- snippet engine
  use 'rafamadriz/friendly-snippets' -- a bunch of snippets to use

  -- Highlight, edit, and navigate code
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() -- auto install languages
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }
  -- Additional text objects via treesitter + playground
  use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' }
  use { 'nvim-treesitter/playground', after = 'nvim-treesitter' }

  -- Fuzzy Finder (files, lsp, etc) + Plenary (common neovim lua utils)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
  use { -- fuzzy finder algorithm which requires local dependencies to be built, only load if `make` is available
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable 'make' == 1,
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- Colorschemes
  use 'navarasu/onedark.nvim'
  use 'folke/tokyonight.nvim'

  -- Snazzy statusline, bufferline & file tree
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-tree.lua'
  -- use { 'akinsho/bufferline.nvim', tag = 'v3.*' }

  -- Auto comment, tsx enabled via context. ("gc" to comment visual regions/lines).
  use { 'numToStr/Comment.nvim', requires = { 'JoosepAlviste/nvim-ts-context-commentstring' } }

  -- Auto pairs and tags ("", </>)
  use 'windwp/nvim-ts-autotag'
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  }
  -- Misc --
  use 'kyazdani42/nvim-web-devicons' -- required by many other plugins
  use 'lukas-reineke/indent-blankline.nvim' -- add indentation guides even on blank lines
  use 'tpope/vim-sleuth' -- detect tabstop and shiftwidth automatically
  use 'p00f/nvim-ts-rainbow' -- colored parenthesis

  -- Markdown (plugins can have post-install/update hooks)
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' }

  if is_bootstrap then -- auto download and compile on first use
    require('packer').sync()
  end
end)
