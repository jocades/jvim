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
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  jsonls = {},
  tsserver = {},
}

-- Enable the following langauge formatters
M.formatters = {
  'prettierd',
  'autopep8',
  'stylua',
}

-- Initial config
M.init = function()
  vim.diagnostic.config {
    -- virtual_text = false, -- disable in-line text diagnostic
    virtual_text = { spacing = 4, prefix = '●' },
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
M.on_attach = function(client, bufnr)
  if client.name == 'tsserver' then
    local map = require('utils').map
    local ts = require 'typescript'
    map('n', '<leader>tO', ts.actions.organizeImports, { buffer = bufnr, desc = 'Organize Imports' })
    map('n', '<leader>tM', ts.actions.addMissingImports, { desc = 'Add Missing Imports', buffer = bufnr })
    map('n', '<leader>tU', ts.actions.removeUnused, { desc = 'Remove unused imports', buffer = bufnr })
    map('n', '<leader>tR', function() ts.renameFile() end, { desc = 'Rename File', buffer = bufnr })
    --client.server_capabilities.documentFormattingProvider = false
  end

  --if client.server_capabilities.documentSymbolProvider then
  -- require('nvim-navic').attach(client, bufnr)
  --end
  require 'plugins.lsp.mappings'(bufnr) -- load keymaps
  pcall(require('illuminate').on_attach, client) -- highlights
end

return M
