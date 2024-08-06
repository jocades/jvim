local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lib.globals')
require('lvim.global')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

---@class LVimOptions
---@field colorscheme? string

---@param opts? LVimOptions
local function setup(opts)
  opts = opts or {}

  require('lazy').setup({
    spec = {
      { import = 'plugins' },
      { import = 'plugins.ui' },
      { import = 'plugins.coding' },
    },
    checker = {
      enabled = true,
      notify = false,
    },
    change_detection = {
      notify = false,
    },
    install = {
      colorscheme = { opts.colorscheme },
    },
    dev = {
      path = '~/dev/neovim/plugins',
      patterns = {},
      fallback = false,
    },
  })

  if opts.colorscheme then vim.cmd.colorscheme(opts.colorscheme) end

  require('config.autocmds')

  for k, v in pairs(require('config.options')) do
    vim.opt[k] = v
  end

  require('config.commands')
  require('config.ft')
  require('lib.plugins')
  require('lib.snippets')

  local map = require('utils').map
  for mode, keymaps in pairs(require('config.keymaps')) do
    for k, t in pairs(keymaps) do
      map(mode, k, t[1], t[2])
    end
  end
end

return {
  setup = setup,
}
