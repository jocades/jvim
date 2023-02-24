return {
  { 'kyazdani42/nvim-web-devicons', lazy = true },
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    config = true,
  },
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'b0o/incline.nvim', event = 'BufReadPre', config = true },
}
