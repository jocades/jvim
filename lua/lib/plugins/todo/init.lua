-- Display the contents of the TODO.md file in quickfix list
-- Add the possibility to add locations to the quickfix list whiwhc will be added to the todo item.
-- so that we can go to a specific location fro that todo item.

local Popup = require('nui.popup')
local h = require('utils.api')
local str = require('utils.str')
local Path = require('lib.path')
local event = require('nui.utils.autocmd').event

local M = {}

local augroup = vim.api.nvim_create_augroup('Todo', { clear = true })

local function create_popup(buf)
  return Popup({
    bufnr = buf,
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
        bottom = 'save (<leader>s) | close (<leader>tt)',
        bottom_align = 'center',
      },
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  })
end

local cwd = Path.is_nvim() and Path('~/.config/nvim/lua/lib/plugins/todo')
  or Path.cwd()

---@type NuiPopup
local popup
local is_mounted = false
local is_open = false
local file = cwd / 'TODO.md'
local lock = cwd / '.TODO.lock'

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
      -- crate a buffer and attach it to the TODO.md file
      -- then just open the popup with that bufnr

      -- how to open a buffer in the background and just hide it and load the popup with that bufnr
      vim.cmd('e ' .. file.abs)
      popup = create_popup(vim.api.nvim_get_current_buf())
      vim.cmd('bd')
      popup:mount()
      is_mounted = true

      local content = file.readlines()
      h.write_to_buf(popup.bufnr, content)
    end

    toggle()
  end)

  vim.keymap.set('n', '<leader>ti', function()
    if not is_open then toggle() end
    vim.api.nvim_set_current_win(popup.winid)
  end)

  vim.keymap.set('n', '<leader>s', function()
    print('writing')
    file.write(vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)

  vim.api.nvim_create_autocmd(event.BufWritePost, {
    group = augroup,
    pattern = file.abs,
    callback = function()
      local content = file.readlines()
      h.write_to_buf(popup.bufnr, content)
    end,
  })
end

M.setup()

return M
