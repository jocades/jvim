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

-- Initial config (mainly UI related)
require('j0rdi.lsp.setup').init()

-- Language servers to be installed automatically
local servers = require('j0rdi.lsp.setup').servers

-- MASON handles neovim's built-in LSP config, auto installs servers,
-- and sets up handlers (capabilities, on_attach, etc.), see `:Mason`
mason.setup {
  ensure_installed = require('j0rdi.lsp.setup').formatters,
  automatic_installation = true,
}

lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
}

lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = require('j0rdi.lsp.setup').capabilities,
      on_attach = require('j0rdi.lsp.setup').on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- Turn on formatting with null-ls (prettier, autopep8, etc.)
require 'j0rdi.lsp.null-ls'
