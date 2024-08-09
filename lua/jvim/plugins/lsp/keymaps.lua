local lsp = vim.lsp.buf
local telescope = require('telescope.builtin')

local M = {}

local keymaps = {
  -- Movement
  { 'gd', lsp.definition, 'Goto Definition' },
  { 'gr', telescope.lsp_references, 'Goto References' },
  { '<leader>D', lsp.type_definition, 'Type Definition' },
  { 'gI', lsp.implementation, 'Goto Implementation' },
  --stylua: ignore start
  { '<leader>dl', '<cmd>TroubleToggle document_diagnostics<cr>', 'Document Diagnostics (Trouble)' },
  { '<leader>dp', '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Workspace Diagnostics (Trouble)' },
  --stylua: ignore end
  { ']d', vim.diagnostic.goto_next, 'Goto Next Diagnostic' },
  { '[d', vim.diagnostic.goto_prev, 'Goto Previous Diagnostic' },
  { ']e', JVim.lsp.diagnostic_goto(true, 'ERROR'), 'Goto Next Error' },
  { '[e', JVim.lsp.diagnostic_goto(false, 'ERROR'), 'Goto Previous Error' },
  { ']w', JVim.lsp.diagnostic_goto(true, 'WARNING'), 'Goto Next Warning' },
  { '[w', JVim.lsp.diagnostic_goto(false, 'WARNING'), 'Goto Previous Warning' },

  -- Actions
  { 'K', lsp.hover, 'Hover Documentation' },
  { '<leader>k', vim.diagnostic.open_float, 'Open diag float' },
  { '<leader>rn', lsp.rename, 'Rename' },
  { '<leader>ca', lsp.code_action, 'Code Action' },
  { '<leader>ds', telescope.lsp_document_symbols, 'Document Symbols' },
  {
    '<leader>ws',
    telescope.lsp_dynamic_workspace_symbols,
    'Workspace Symbols',
  },
  { 'gK', vim.lsp.buf.signature_help, 'Signature Documentation' },

  -- Less used
  { 'gD', lsp.declaration, 'Goto Declaration' },
  { '<leader>wa', lsp.add_workspace_folder, 'Workspace Add Folder' },
  { '<leader>wr', lsp.remove_workspace_folder, 'Workspace Remove Folder' },
  { '<leader>wl', lsp.list_workspace_folders, 'Workspace List Folders' },
}

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
    opts.desc = 'LSP: ' .. opts.desc
  end)
end

return M
