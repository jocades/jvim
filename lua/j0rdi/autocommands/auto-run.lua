-- I want to creat a command which:
-- attaches to te current buffer, runs the curerent file,
-- and displays the ouput in a new buffer to the right of the current buffer.
-- I want to be able to run this command from the command line,
-- or from a keybinding.

-- If it is the first time the command is run, it will ask for the command to run.
-- i.e. "python", "node", "bash", etc.
-- If it is not the first time, it will use the last command used.

-- test: create a user command which creates a buffer and appends 'hello world' to id

vim.api.nvim_create_user_command('Function', function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'hello world' })
  vim.api.nvim_win_set_buf(0, buf)
  -- i want the ffer to be split to the right of the current buffer
  -- and the cursor should stay in the current buffer

  vim.cmd.split()
  vim.cmd.wincmd 'l'

  -- i want the buffer to be split to the right of the current buffer
  --
end, {})
