-- This function gets run when an LSP connects to a particular buffer.
return function(client, bufnr)
  local function nmap(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  if client.name == 'tsserver' then
    client.server_capabilities.documentFormattingProvider = false
  end

  -- KEYMAPS
  local lsp = vim.lsp.buf
  local K = {
    -- Common
    ['<leader>rn'] = { lsp.rename, 'Rename' },
    ['<leader>ca'] = { lsp.code_action, 'Code Action' },
    ['gd'] = { lsp.definition, 'Goto Definition' },
    ['gr'] = { require('telescope.builtin').lsp_references, 'Goto References' },
    ['gI'] = { lsp.implementation, 'Goto Implementation' },
    ['<leader>D'] = { lsp.type_definition, 'Type Definition' },
    ['<leader>ds'] = { require('telescope.builtin').lsp_document_symbols, 'Document Symbols' },
    ['<leader>ws'] = { require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols' },
    ['K'] = { lsp.hover, 'Hover Documentation' },
    -- ['<C-K>'] = { vim.lsp.buf.signature_help, 'Signature Documentation' },

    -- Less used
    ['gD'] = { lsp.declaration, 'Goto Declaration' },
    ['<leader>wa'] = { lsp.add_workspace_folder, 'Workspace Add Folder' },
    ['<leader>wr'] = { lsp.remove_workspace_folder, 'Workspace Remove Folder' },
    ['<leader>wl'] = {
      function()
        print(vim.inspect(lsp.list_workspace_folders()))
      end,
      'Workspace List Folders',
    },
  }

  for k, v in pairs(K) do
    nmap(k, v[1], v[2])
  end

  -- HIGHLIGHTS
  pcall(require('illuminate').on_attach, client)
end
