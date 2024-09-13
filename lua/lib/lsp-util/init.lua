local client_id = vim.lsp.start_client({
  name = 'educationalsp',
  cmd = { '/Users/j0rdi/dev/lsp/educationalsp/main' },
  on_attach = require('jvim.plugins.lsp.keymaps').on_attach,
})

if not client_id then
  JVim.warn("No client attached to 'educationalsp'")
  return
else
  JVim.info('Client attached ' .. client_id)
end

JVim.autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.lsp.buf_attach_client(0, client_id)
  end,
})
