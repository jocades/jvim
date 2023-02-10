vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy').setup {
  { import = 'plugins' },
  { import = 'plugins.ui' },
  { import = 'plugins.coding' },
}

require('config.autocmds')
require('config.options')
require('config.mappings')
require('utils.lib')
