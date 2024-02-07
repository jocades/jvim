return {
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    config = function()
      require('nvim-web-devicons').setup({
        strict = true,
        override_by_extension = {
          astro = {
            icon = '',
            color = '#EF8547',
            name = 'astro',
          },
        },
      })
    end,
  },
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      user_default_options = {
        -- background, foreground, virtualtext
        mode = 'foreground',
        tailwind = true,
      },
    },
  },
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'b0o/incline.nvim', event = 'BufReadPre', config = true },
}
