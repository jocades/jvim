-- Display the contents of the TODO.md file in quickfix list
-- Add the possibility to add locations to the quickfix list whiwhc will be added to the todo item.
-- so that we can go to a specific location fro that todo item.

local Popup = require('nui.popup')
local h = require('utils.api')
local str = require('utils.str')
local Path = require('lib.path')

local M = {}

local function create_popup()
  return Popup({
    relative = 'editor',
    -- enter = true,
    focusable = true,
    position = {
      row = '90%',
      col = '99%',
    },
    size = {
      width = 50,
      height = 20,
    },
    border = {
      style = 'rounded',
      text = {
        top = 'Todo',
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
end

---@type NuiPopup
local popup
local is_mounted = false
local is_open = false
local file = Path('~/.config/nvim/lua/lib/plugins/todo/TODO.md')

local function toggle()
  if is_open then
    popup:hide()
    is_open = false
  else
    popup:show()
    is_open = true
  end
end

M.setup = function()
  vim.keymap.set('n', '<leader>tt', function()
    if not is_mounted then
      popup = create_popup()
      popup:mount()
      is_mounted = true

      local content = file.readlines()
      h.write_to_buf(popup.bufnr, content)

      -- local chunks = str.split(content, '---')
      -- P(chunks)
    end

    toggle()
  end)
end

M.setup()

return M
