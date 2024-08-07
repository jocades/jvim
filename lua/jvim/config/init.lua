_G.JVim = require('jvim.utils')

require('jvim.config.options')
require('jvim.lib.globals')

local M = {}

---@param opts? JVimOptions
function M.setup(opts)
  opts = opts or {}

  require('lazy').setup({
    { import = 'jvim.plugins' },
    { import = 'jvim.plugins.ui' },
    { import = 'jvim.plugins.coding' },
  }, {
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
      path = opts.dev,
      patterns = {},
      fallback = false,
    },
  })

  if opts.colorscheme then
    vim.cmd.colorscheme(opts.colorscheme)
  end

  require('jvim.config.autocmds')
  require('jvim.lib.plugins')
  require('jvim.lib.snippets')

  JVim.keymap.register(require('jvim.config.keymaps'))
end

return M
