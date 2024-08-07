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

require('jvim.global')
require('jvim.lib.globals')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

---@class LVimOptions
---@field colorscheme? string

---@param opts? LVimOptions
local function setup(opts)
  opts = opts or {}

  require('lazy').setup({
    spec = {
      { import = 'jvim.plugins' },
      { import = 'jvim.plugins.ui' },
      { import = 'jvim.plugins.coding' },
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

  require('jvim.config.autocmds')
  require('jvim.config.options')
  require('jvim.config.commands')
  require('jvim.config.ft')
  require('jvim.lib.plugins')
  require('jvim.lib.snippets')
  require('jvim.config.colors')

  JVim:register(require('jvim.config.keymaps'))
end

return {
  setup = setup,
}
