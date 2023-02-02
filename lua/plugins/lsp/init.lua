-- LSP Configuration & Plugins
return {
  'neovim/nvim-lspconfig',
  event = 'BufReadPre',
  dependencies = {
    'williamboman/mason.nvim', -- automatically install LSPs to stdpath for neovim
    'williamboman/mason-lspconfig.nvim', -- lspconfig setup (capabilites, on_attach, etc)
    'j-hui/fidget.nvim', -- lsp status UI
    { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
    { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } }, -- additional lua configuration (neovim globals, require paths cmp, etc)
    'jose-elias-alvarez/null-ls.nvim', -- attaches to a LS and allows formatting, additional linting, etc.
  },

  config = function()
    -- MASON handles neovim's built-in LSP config, auto installs servers,
    -- and sets up handlers (capabilities, on_attach, etc.), see `:Mason`
    require('mason').setup {
      ensure_installed = require('plugins.lsp.setup').formatters,
    }

    local lspconfig = require 'mason-lspconfig'

    require('plugins.lsp.setup').init()
    local servers = require('plugins.lsp.setup').servers

    lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
    }

    lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = require('plugins.lsp.setup').capabilities,
          on_attach = require('plugins.lsp.setup').on_attach,
          settings = servers[server_name],
        }
      end,
    }

    -- Turn on formatting with null-ls (prettier, autopep8, etc.)
    require 'plugins.lsp.null-ls'
  end,
}
