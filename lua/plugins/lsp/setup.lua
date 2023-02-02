local present, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not present then
  return
end

local M = {}

-- Add default & share nvim-cmp's additional completion capabailities
local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Enable the following language servers
M.servers = {
  pyright = {
    analysis = {
      typeCheckingMode = 'off',
    },
  },
  sumneko_lua = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  jsonls = {},
  tsserver = {},
}

-- Enable the following langauge formatters
M.formatters = {
  'prettier',
  'autopep8',
  'stylua',
}

-- Initial config
M.init = function()
  vim.diagnostic.config {
    virtual_text = false, -- disable in-line text diagnostic
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      source = 'always',
    },
  }
end

-- This function gets run when an LSP connects to a particular buffer.
-- It is used to set up keymaps and other things.
M.on_attach = function(client, bufnr)
  if client.name == 'tsserver' then
    client.server_capabilities.documentFormattingProvider = false
  end

  require 'plugins.lsp.mappings'(bufnr) -- load keymaps
  pcall(require('illuminate').on_attach, client) -- highlights
end

return M
