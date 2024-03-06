local Popup = require('nui.popup')
local h = require('utils.api')

local pop = {
  bottom_right = function(title)
    return Popup({
      relative = 'editor',
      -- enter = true,
      focusable = true,
      position = {
        row = '90%',
        col = '99%',
      },
      size = {
        width = 20,
        height = 8,
      },
      border = {
        style = 'rounded',
        text = {
          top = title and string.format(' %s ', title) or ' Links ',
          top_align = 'center',
          -- bottom = 'I am bottom title',
          -- bottom_align = 'left',
        },
      },
      buf_options = {
        modifiable = true,
        readonly = false,
      },
    })
  end,
}

-- local p = pop.bottom_right()
-- p:mount()

-- h.write_to_buf(p.bufnr, { 'Hello', 'World' })

-- focus the popup
--[[ vim.keymap.set(
  'n',
  '<leader>i',
  function() vim.api.nvim_set_current_win(p.winid) end,
  { noremap = true, silent = true }
) ]]

return pop
