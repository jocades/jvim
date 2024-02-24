local Popup = require('nui.popup')
local h = require('utils.api')

local popup = Popup({
  position = '50%',
  size = {
    width = 80,
    height = 40,
  },
  enter = true,
  focusable = true,
  zindex = 50,
  relative = 'editor',
  border = {
    padding = {
      top = 2,
      bottom = 2,
      left = 3,
      right = 3,
    },
    style = 'rounded',
    text = {
      top = ' I am top title ',
      top_align = 'center',
      bottom = 'I am bottom title',
      bottom_align = 'left',
    },
  },
  buf_options = {
    modifiable = true,
    readonly = false,
  },
  win_options = {
    winblend = 10,
    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  },
})

-- popup:mount()
local pop = {
  bottom_right = function()
    return Popup({
      bufnr = vim.api.nvim_get_current_buf(),
      relative = 'editor',
      enter = true,
      focusable = true,
      position = {
        row = 90,
        col = 90,
      },
      size = {
        width = 40,
        height = 20,
      },
      border = {
        style = 'rounded',
        text = {
          top = ' I am top title ',
          top_align = 'center',
          bottom = 'I am bottom title',
          bottom_align = 'left',
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
--
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
