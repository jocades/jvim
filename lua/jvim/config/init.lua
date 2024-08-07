_G.JVim = require('jvim.utils')

local M = {}

local function load(name)
  local function _load(mod)
    if require('lazy.core.cache').find(mod)[1] then
      print('require', mod)
      require(mod)
    end
  end
end

---@param opts? JVimOptions
function M.setup(opts)
  opts = opts or {}

  require('jvim.config.options')
  require('jvim.lib.globals')

  -- autocmds can be loaded lazily when not opening a file
  -- local lazy_autocmds = vim.fn.argc(-1) == 0
  if true then
    -- vim.notify('dont lazy load')
    -- M.load("autocmds")
  end

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
      notify = true,
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
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
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

  JVim.keymap.register(require('jvim.config.keymaps'))
end

return M
