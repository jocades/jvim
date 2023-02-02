-- local nightowl = '#011627'
-- local onedark = '#282c34'
--
return {
  'folke/tokyonight.nvim',
  config = function()
    require('tokyonight').setup {
      on_highlights = function(hl, c)
        -- I like tildes
        hl.EndOfBuffer = { fg = c.dark5 }
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
    }

    vim.cmd [[colorscheme tokyonight]]
  end,
}
