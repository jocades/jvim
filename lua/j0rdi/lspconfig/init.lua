require('j0rdi.lspconfig.setup').init()

-- MASON takes care of the LSP config & handlers (capabilities, on_attach, etc.), see `:Mason`
local mason_present, mason = pcall(require, 'mason')
if not mason_present then
  return
end

local lspconfig_present, lspconfig = pcall(require, 'mason-lspconfig')
if not lspconfig_present then
  return
end

-- Setup neovim lua configuration (vim globals)
require('neodev').setup()

-- List of language servers to install automatically
local servers = require('j0rdi.lspconfig.setup').servers

mason.setup {
  ensure_installed = require('j0rdi.lspconfig.setup').formatters,
  automatic_installation = true,
}

lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
}

lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = require('j0rdi.lspconfig.setup').capabilities,
      on_attach = require 'j0rdi.lspconfig.on-attach',
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()
