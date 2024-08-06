require('lib.globals')
require('lvim.global')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function modules()
  return {
    { import = 'plugins' },
    { import = 'plugins.ui' },
    { import = 'plugins.coding' },
  }
end

require('lazy').setup(modules(), {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  dev = {
    path = '~/dev/neovim/plugins',
    patterns = {},
    fallback = false,
  },
})

require('config.autocmds')

for k, v in pairs(require('config.options')) do
  vim.opt[k] = v
end

require('config.commands')
require('config.ft')
require('lib.plugins')
require('lib.snippets')

for mode, keymaps in pairs(require('config.keymaps')) do
  for k, t in pairs(keymaps) do
    require('utils').map(mode, k, t[1], t[2])
  end
end
