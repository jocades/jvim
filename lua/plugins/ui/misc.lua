return {
  { 'kyazdani42/nvim-web-devicons', lazy = true },
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'b0o/incline.nvim', event = 'BufReadPre', config = true },
}
