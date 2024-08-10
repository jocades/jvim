_G.JVim = require('jvim.util')

local M = {}

---@param opts? JVimOpts
function M.setup(opts)
  opts = opts or {}

  JVim.load('options')

  require('lazy').setup({ import = 'jvim.plugins' }, {
    change_detection = { notify = false },
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
          -- 'matchit',
          -- 'matchparen',
          'netrwPlugin',
          'tarPlugin',
          -- 'tohtml',
          'tutor',
          -- 'zipPlugin',
        },
      },
    },
  })

  if opts.colorscheme then
    vim.cmd.colorscheme(opts.colorscheme)
  end

  JVim.load('autocmds')
  JVim.on_very_lazy(function()
    JVim.register(JVim.load('keymaps'))
  end)
end

return M
