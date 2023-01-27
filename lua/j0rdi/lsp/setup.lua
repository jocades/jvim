local M = {}

-- Add default & share nvim-cmp's additional completion capabailities
local present, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not present then
  return
end

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
  'prettier',
  'autopep8',
  'stylua',
}

-- Initial config (mainly UI related)
M.init = function()
  -- local signs = {
  --   { name = 'DiagnosticSignError', text = '' },
  --   { name = 'DiagnosticSignWarn', text = '' },
  --   { name = 'DiagnosticSignHint', text = '' },
  --   { name = 'DiagnosticSignInfo', text = '' },
  -- }
  --
  -- for _, sign in ipairs(signs) do
  --   vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  -- end

  vim.diagnostic.config {
    virtual_text = false, -- disable in-line text diagnostic
    -- signs = { -- show signs
    --   active = signs,
    -- },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
end

return M
