return {
  'kyazdani42/nvim-web-devicons', -- required by many other plugins
  require 'plugins.ui.lualine',
  require 'plugins.ui.nvimtree',
  require 'plugins.ui.indent-blankline',
  require 'plugins.ui.bufferline',
  require 'plugins.ui.alpha',
  { 'NvChad/nvim-colorizer.lua', config = true }, -- color highlighter
}
