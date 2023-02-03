local lsp = vim.lsp.buf
local telescope = require 'telescope.builtin'
local map = require('utils').map

-- LSP KEYMAPS
local K = {
  -- Common
  ['<leader>rn'] = { lsp.rename, 'Rename' },
  ['<leader>ca'] = { lsp.code_action, 'Code Action' },
  ['gd'] = { lsp.definition, 'Goto Definition' },
  ['gr'] = { telescope.lsp_references, 'Goto References' },
  ['gI'] = { lsp.implementation, 'Goto Implementation' },
  ['<leader>D'] = { lsp.type_definition, 'Type Definition' },
  ['<leader>ds'] = { telescope.lsp_document_symbols, 'Document Symbols' },
  ['<leader>ws'] = { telescope.lsp_dynamic_workspace_symbols, 'Workspace Symbols' },
  ['K'] = { lsp.hover, 'Hover Documentation' },
  -- ['<C-K>'] = { vim.lsp.buf.signature_help, 'Signature Documentation' },

  -- Less used
  ['gD'] = { lsp.declaration, 'Goto Declaration' },
  ['<leader>wa'] = { lsp.add_workspace_folder, 'Workspace Add Folder' },
  ['<leader>wr'] = { lsp.remove_workspace_folder, 'Workspace Remove Folder' },
  ['<leader>wl'] = { function() print(vim.inspect(lsp.list_workspace_folders())) end, 'Workspace List Folders' },
}

return function(bufnr)
  for k, v in pairs(K) do
    map('n', k, v[1], { buffer = bufnr, desc = 'LSP: ' .. v[2] })
  end
end
