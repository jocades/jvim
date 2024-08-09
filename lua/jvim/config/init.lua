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

  if vim.fn.argc(-1) == 0 then
    JVim.on_very_lazy(function()
      require('jvim.config.autocmds')
      require('jvim.lib.snippets')
    end)
  end

  JVim.register(require('jvim.config.keymaps'))

  -- JVim.on_very_lazy(function()
  --   require('jvim.lib.snippets')
  -- end)
end

return M
