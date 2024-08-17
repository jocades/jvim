vim.keymap.set('n', '<leader>do', function()
  local win = vim.api.nvim_get_current_win()
  local ln = vim.api.nvim_win_get_cursor(win)[1]
  vim.api.nvim_buf_set_lines(0, ln, ln, false, { '/**', '* ', '*/' })
  vim.cmd.normal('jj')
  vim.cmd('startinsert!')
end, { desc = 'JSDoc' })