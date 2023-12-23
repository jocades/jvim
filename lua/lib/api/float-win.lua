-- how to create a new window just to show some output
local buf = vim.api.nvim_create_buf(false, true)

vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'Hello, world!' })

local open = true

-- open a split window and set its buffer
local win = vim.api.nvim_open_win(buf, true, {
  relative = 'editor',
  width = 50,
  height = 150,
  row = 0,
  col = 0,
  style = 'minimal',
})

local M = {}

M.toggle_win = function()
  if open then
    vim.api.nvim_win_close(win, true)
    open = false
  else
    vim.api.nvim_win_close(win, true)
    open = true
  end
end

vim.api.nvim_create_user_command('ToggleWin', function() vim.api.nvim_win_close(win, true) end, {})

return M
