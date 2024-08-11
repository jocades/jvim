if vim.env.JVIM_TEST then
  JVim.autocmd('BufReadPre', {
    callback = function()
      print('BufReadPre!!!')
    end,
  })

  vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
      print('BufReadPost!!!')
    end,
  })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Check if we need to reload the file when it changed
JVim.autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    vim.o.formatoptions = 'jqlnt' -- dont add comment on new line

    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set wrap and spell for some filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'text', 'plaintex', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Disable syntax highlighting when opening big files
vim.filetype.add({
  pattern = {
    ['.*'] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= 'bigfile'
            and path
            and vim.fn.getfsize(path) > vim.g.bigfile_size
            and 'bigfile'
          or nil
      end,
    },
  },
})

JVim.autocmd({ 'FileType' }, {
  pattern = 'bigfile',
  callback = function(e)
    vim.schedule(function()
      vim.bo[e.buf].syntax = vim.filetype.match({ buf = e.buf }) or ''
      JVim.warn('Big file detected')
    end)
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'qf',
    'help',
    'man',
    'notify',
    'startuptime',
  },
  callback = function(e)
    vim.bo[e.buf].buflisted = false
    vim.keymap.set('n', 'q', vim.cmd.q, { buffer = e.buf, silent = true })
  end,
})
