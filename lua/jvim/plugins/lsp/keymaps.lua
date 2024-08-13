local telescope = require('telescope.builtin')
-- local trouble = require('trouble')

local M = {}

local keymaps = {
  -- Movement
  { 'gd', vim.lsp.buf.definition, 'Goto Definition' },
  { 'gr', telescope.lsp_references, 'Goto References' },
  { 'gD', vim.lsp.buf.declaration, 'Goto Declaration' },
  { 'gtd', vim.lsp.buf.type_definition, 'Type Definition' },
  { 'gI', vim.lsp.buf.implementation, 'Goto Implementation' },
  { '<leader>dd', '<cmd>Trouble diagnostics toggle<cr>', 'Diagnostics' },
  { ']d', vim.diagnostic.goto_next, 'Goto Next Diagnostic' },
  { '[d', vim.diagnostic.goto_prev, 'Goto Previous Diagnostic' },
  { ']e', JVim.lsp.diagnostic_goto(true, 'ERROR'), 'Goto Next Error' },
  { '[e', JVim.lsp.diagnostic_goto(false, 'ERROR'), 'Goto Previous Error' },
  { ']w', JVim.lsp.diagnostic_goto(true, 'WARNING'), 'Goto Next Warning' },
  { '[w', JVim.lsp.diagnostic_goto(false, 'WARNING'), 'Goto Previous Warning' },

  -- Actions
  { 'K', vim.lsp.buf.hover, 'Hover Documentation' },
  { '<leader>k', vim.diagnostic.open_float, 'Open diag float' },
  { '<leader>rn', vim.lsp.buf.rename, 'Rename' },
  { '<leader>ca', vim.lsp.buf.code_action, 'Code Action' },
  { '<leader>ds', telescope.lsp_document_symbols, 'Document Symbols' },
  {
    '<leader>ws',
    telescope.lsp_dynamic_workspace_symbols,
    'Workspace Symbols',
  },
}

---@param client vim.lsp.Client
---@param buf integer
function M.on_attach(client, buf)
  if client.name == 'tsserver' then
    local ts = require('typescript')
    --stylua: ignore
    vim.list_extend(keymaps, {
      { '<leader>tO', ts.actions.organizeImports, 'Organize Imports (ts)', },
      { '<leader>tM', ts.actions.addMissingImports, 'Add Missing Imports (ts)', },
      { '<leader>tU', ts.actions.removeUnused, 'Remove Unused Imports (ts)', },
      { '<leader>tR', function() ts.renameFile() end, 'Rename File (ts)', },
    })
  end

  if client.name == 'ruff_lsp' then
    client.server_capabilities.hoverProvider = false
  end

  JVim.register(keymaps, function(opts)
    opts.buffer = buf
    opts.desc = 'LSP ' .. opts.desc
  end)
end

return M
