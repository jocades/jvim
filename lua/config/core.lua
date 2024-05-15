require('lib.globals')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local modules = {
  'plugins',
  'plugins.ui',
  'plugins.coding',
}

require('lazy').setup(
  table.reduce(modules, function(acc, mod)
    table.insert(acc, { import = mod })
    return acc
  end, {}),
  {
    checker = {
      enabled = true,
      notify = false,
    },
    change_detection = {
      notify = false,
    },
    dev = {
      path = '~/dev/plugins',
      patterns = {},
      fallback = false,
    },
  }
)

require('config.autocmds')
require('config.options')
require('config.keymaps')
require('config.ft')
require('lib.plugins')
require('lib.snippets')
