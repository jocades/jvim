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
    ---@module "go-tools"
    ---@type gotools.Opts
    opts = {
      gotest = {
        split = "bottom",
      },
      gotags = {
        tags = "json",
        transform = "camelcase",
      },
    },
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
