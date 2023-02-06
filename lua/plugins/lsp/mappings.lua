local lsp = vim.lsp.buf
local telescope = require 'telescope.builtin'

local M = {}

local mappings = {
  -- Movement
  ['[d'] = { vim.diagnostic.goto_prev, 'Goto Previous Diagnostic' },
  [']d'] = { vim.diagnostic.goto_next, 'Goto Next Diagnostic' },
  ['gd'] = { lsp.definition, 'Goto Definition' },
  ['gr'] = { telescope.lsp_references, 'Goto References' },
  ['<leader>D'] = { lsp.type_definition, 'Type Definition' },
  ['gI'] = { lsp.implementation, 'Goto Implementation' },
  ['<leader>dp'] = { vim.diagnostic.setqflist, 'Show all diagnostics in quickfix' },
  ['<leader>dl'] = { vim.diagnostic.setloclist, 'Show diagnostics in quickfix' },

  -- Actions
  ['K'] = { lsp.hover, 'Hover Documentation' },
  ['<leader>k'] = { vim.diagnostic.open_float, 'Open diag float' },
  ['<leader>rn'] = { lsp.rename, 'Rename' },
  ['<leader>ca'] = { lsp.code_action, 'Code Action' },
  ['<leader>ds'] = { telescope.lsp_document_symbols, 'Document Symbols' },
  ['<leader>ws'] = { telescope.lsp_dynamic_workspace_symbols, 'Workspace Symbols' },
  -- ['<C-K>'] = { vim.lsp.buf.signature_help, 'Signature Documentation' },

  -- Less used
  ['gD'] = { lsp.declaration, 'Goto Declaration' },
  ['<leader>wa'] = { lsp.add_workspace_folder, 'Workspace Add Folder' },
  ['<leader>wr'] = { lsp.remove_workspace_folder, 'Workspace Remove Folder' },
  ['<leader>wl'] = { function() print(vim.inspect(lsp.list_workspace_folders())) end, 'Workspace List Folders' },
}

function M.on_attach(client, bufnr)
  if client.name == 'tsserver' then
    local ts = require 'typescript'
    mappings['<leader>tO'] = { ts.actions.organizeImports, 'Organize Imports' }
    mappings['<leader>tM'] = { ts.actions.addMissingImports, 'Add Missing Imports' }
    mappings['<leader>tU'] = { ts.actions.removeUnused, 'Remove unused imports' }
    mappings['<leader>tR'] = { function() ts.renameFile() end, 'Rename File' }
  end

  for k, v in pairs(mappings) do
    require('utils').map('n', k, v[1], { buffer = bufnr, desc = 'LSP: ' .. v[2] })
  end
end

return M
