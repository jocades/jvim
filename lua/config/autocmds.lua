-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd(
  { 'FocusGained', 'TermClose', 'TermLeave' },
  { command = 'checktime' }
)

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
})

-- Resize splits if window got resized
-- vim.api.nvim_create_autocmd({ 'VimResized' }, {
--   callback = function() vim.cmd('tabdo wincmd =') end,
-- })

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'qf',
    'help',
    'man',
    'notify',
    'lspinfo',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'PlenaryTestPopup',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set(
      'n',
      'q',
      '<cmd>close<cr>',
      { buffer = event.buf, silent = true }
    )
  end,
})

-- Set wrap and spell for some filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Set correct indent for languages I made, create syntax highlighting in the future
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.ene', '*.lox' },
  callback = function()
    print('LOX or ENE file detected')
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})
