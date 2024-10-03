return {
  {
    "test",
    enabled = false,
    dev = true,
    opts = {},
    config = function()
      require("test").setup()
    end,
  },

  {
    "bquik",
    enabled = false,
    dev = true,
  },

  {
    "jocades/go-tools.nvim",
    -- enabled = false,
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
    enabled = false,
    dev = true,
    ---@module 'twf'
    ---@type TwfOpts
    opts = {
      enabled = true,
      -- highlight = {},
    },
  },
}
