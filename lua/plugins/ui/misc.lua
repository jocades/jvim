return {
  { 'kyazdani42/nvim-web-devicons', lazy = true },
  require 'plugins.ui.lualine',
  require 'plugins.ui.nvimtree',
  require 'plugins.ui.indent-blankline',
  require 'plugins.ui.bufferline',
  require 'plugins.ui.alpha',
  require 'plugins.ui.notify',
  { 'NvChad/nvim-colorizer.lua', lazy = true, config = true },
}
