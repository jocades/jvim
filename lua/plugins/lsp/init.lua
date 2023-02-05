--
--
-- LSP Configuration & Plugins
--
local M = {}

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'williamboman/mason.nvim', -- automatically install LSPs to stdpath for neovim
      'williamboman/mason-lspconfig.nvim', -- lspconfig setup (capabilites, on_attach, etc)
      { 'j-hui/fidget.nvim', config = true }, -- lsp status UI
      { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
      { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } }, -- additional lua configuration (neovim globals, require paths cmp, etc)
      'jose-elias-alvarez/null-ls.nvim', -- attaches to a LS and allows formatting, additional linting, etc.
      { 'jose-elias-alvarez/typescript.nvim', config = true },
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
  },

  -- lsp symbol outline
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    init = function()
      -- vim.g.navic_silence = true
      M.on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, buffer)
        end
      end)
    end,
    opts = { separator = ' ', highlight = true, depth_limit = 5 },
  },
}
