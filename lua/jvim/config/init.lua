_G.JVim = require('jvim.utils')

local M = {}

---@param opts? JVimOptions
function M.setup(opts)
  opts = opts or {}

  require('jvim.config.options')
  require('jvim.lib.globals')

  require('lazy').setup({
    { import = 'jvim.plugins' },
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
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  })

  if opts.colorscheme then
    vim.cmd.colorscheme(opts.colorscheme)
  end

  require('jvim.config.autocmds')
  require('jvim.lib.plugins')
  require('jvim.lib.snippets')

  JVim.register(require('jvim.config.keymaps'))
end

return M
