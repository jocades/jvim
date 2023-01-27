-- This function gets run when an LSP connects to a particular buffer.
--
return function(client, bufnr)
  local nmap = function(keys, func, desc)
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

  nmap('<leader>rn', lsp.rename, '[R]e[n]ame')
  nmap('<leader>ca', lsp.code_action, '[C]ode [A]ction')

  nmap('gd', lsp.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', lsp.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', lsp.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('K', lsp.hover, 'Hover Documentation') -- see `:help K` for why this keymap
  -- nmap('<C-K>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', lsp.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', lsp.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', lsp.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(lsp.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- HIGHLIGHTS
  pcall(require('illuminate').on_attach, client)
end
