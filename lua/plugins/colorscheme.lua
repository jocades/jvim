return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    -- enabled = false,
    config = function()
      vim.cmd([[colorscheme catppuccin]])
      -- vim.cmd([[highlight Normal guibg=none ctermbg=none]])
    end,
  },
  {
    'navarasu/onedark.nvim',
    -- enabled = false,
    -- lazy = true,
    name = 'onedark',
  },
  {
    'rebelot/kanagawa.nvim',
    enabled = true,
    priority = 1000,
    config = function()
      require('kanagawa').setup({
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

      -- vim.cmd([[colorscheme kanagawa]])
    end,
  },
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'bluz71/vim-nightfly-guicolors',
    enabled = false,
    -- priority = 1000,
    -- config = function() vim.cmd([[colorscheme nightfly]]) end,
  },
  {

    'EdenEast/nightfox.nvim',
    enabled = false,
    -- priority = 1000,
    -- config = function() vim.cmd([[colorscheme carbonfox]]) end,
  },
  {
    'folke/tokyonight.nvim',
    -- priority = 1000,
    enabled = false,
    opts = {
      style = 'night',
      on_highlights = function(hl, c)
        hl.EndOfBuffer = { fg = c.dark5 } -- I like tildes
        hl.NvimTreeEndOfBuffer = { fg = c.bg_dark }
        -- TODO: Brighter color for split windows separators
        local prompt = '#2d3149'
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
    -- config = function(_, opts)
    --   require('tokyonight').setup(opts)
    --   vim.cmd([[colorscheme tokyonight-night]])
    -- end,
  },
}
