-- :echo nvim_get_current_buf()
-- :echo nvim_get_current_win()
-- :echo nvim_get_current_tabpage()
-- vim.api.nvim_buf_get_name(0) -- current buffer's path
--

-- write to a specific buffer
local bufnr = 14
-- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'line1', 'line2', 'line3' })

-- `:source %` (source and execute the current lua file)

-- Autocommands (event listeners) allow you to run lua code when certain events occurs (e.g. when a file is opened, when a buffer is changed, etc.)
-- e.g create a command to run a python file and print the output to a new buffer

-- args: 1=event, 2=list of options
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('OnWriteExample', { clear = true }), -- make sure that we dont add more event listeners (autocmds) on top of each other
  pattern = 'run-me.py', -- global if no pattern provided
  callback = function() -- to be executed on event
    print 'Wow, we saved a file!'
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('PrintOutput', { clear = true }),
  pattern = 'run-me.py',
  callback = function()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'Output of: run-me.py' })

    -- 1=list to execute, 2=list to configure the stdout
    vim.fn.jobstart({ 'python', vim.api.nvim_buf_get_name(0) }, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
          -- print(vim.fn.system { 'python', vim.api.nvim_buf_get_name(0) })
        else
          print 'no data'
        end
      end,
      on_stderr = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,
    })
  end,
})
