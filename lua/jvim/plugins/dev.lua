return {
  {
    "test",
    dev = true,
    opts = {},
    config = function()
      require("test").setup()
    end,
  },

  {
    "bquik",
    dev = true,
  },

  {
    "jocades/go-tools.nvim",
    dev = true,
    ft = "go",
    opts = {
      gotest = {},
      gotags = {},
    },
    config = function()
      local go = require("go-tools")
      go.setup()
    end,
  },

  {
    "jocades/twf.nvim",
    dev = true,
    ---@module 'twf'
    ---@type TwfOpts
    opts = {
      enabled = true,
      -- highlight = {},
    },
  },
}
