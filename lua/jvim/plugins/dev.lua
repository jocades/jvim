return {
  {
    'test',
    dev = true,
    opts = {},
    config = function()
      require('test').setup()
    end,
  },

  {
    'bquik',
    dev = true,
  },

  {
    'jocades/twf.nvim',
    dev = true,
    ---@module 'twf'
    ---@type TwfOpts
    opts = {
      enabled = true,
      -- highlight = {},
    },
  },
}
