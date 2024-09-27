return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    ---@module 'catppuccin'
    ---@type CatppuccinOptions
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      show_end_of_buffer = true,
      transparent_background = false,
      no_italic = true,
      integrations = {
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
  },

  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        -- overrides = function(color) end,
        colors = {
          theme = {
            all = {
              syn = {
                -- variable = '#e0e0e0',
                -- constant = '#e0e0e0',
              },
            },
          },
        },
      })
    end,
  },

  {
    "navarasu/onedark.nvim",
    enabled = false,
    name = "onedark",
  },

  {
    "folke/tokyonight.nvim",
    -- priority = 1000,
    enabled = false,
    opts = {
      style = "night",
      on_highlights = function(hl, c)
        hl.EndOfBuffer = { fg = c.dark5 } -- I like tildes
        hl.NvimTreeEndOfBuffer = { fg = c.bg_dark }
        local prompt = "#2d3149"
        hl.TelescopeNormal = {
          bg = c.bg_dark,
          fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopePromptNormal = {
          bg = prompt,
        }
        hl.TelescopePromptBorder = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePromptTitle = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePreviewTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopeResultsTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
      end,
    },
  },
}
