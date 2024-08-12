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

  local function load()
    JVim.load('autocmds')
    JVim.register(JVim.load('keymaps'))
    -- require('bquik')
  end

  if vim.fn.argc(-1) == 0 then
    JVim.on_very_lazy(function()
      load()
    end)
  else
    load()
  end
end

return M
