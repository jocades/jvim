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
      { 'b0o/SchemaStore.nvim', version = false },
      'jose-elias-alvarez/typescript.nvim',
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false, -- disable in-line text diagnostic
        --virtual_text = { spacing = 4, prefix = '●' },
        severity_sort = true,
      },
      autoformat = true,
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- Servers & Settings
      servers = {
        pyright = {
          settings = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              typeCheckingMode = 'off',
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
        tsserver = {},
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(opts.diagnostics)
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local lsp_config = require('mason-lspconfig')
      lsp_config.setup { ensure_installed = vim.tbl_keys(opts.servers) }
      lsp_config.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = require('plugins.lsp.mappings').on_attach,
            settings = opts.servers[server_name].settings,
          }
        end,
      }
    end,
  },

  -- Formatting
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'BufReadPre',
    config = function()
      local b = require('null-ls').builtins
      local sources = {
        --b.diagnostics.flake8,
        b.formatting.autopep8.with { extra_args = { '--max-line-length', '120' } },
        b.formatting.prettierd,
        b.formatting.stylua.with { extra_args = { '--config-path', vim.fn.stdpath('config') .. '/stylua.toml' } },
        b.formatting.shfmt.with { extra_args = { '-i', '4' } },
        b.diagnostics.shellcheck.with { diagnostics_format = '#{m} [#{c}]' },
      }
      require('null-ls').setup {
        debug = true,
        sources = sources,
        on_attach = require('plugins.lsp.formatting').on_attach,
      }
    end,
  },

  -- LS manager
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ensure_installed = {
        'prettierd',
        'autopep8',
        'stylua',
        'shellcheck',
        'shfmt',
        'flake8',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  -- Better diagnostics lists
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
  },
  { 'folke/lsp-colors.nvim', event = 'BufReadPre', config = true },

  -- Lsp symbol outline
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require('utils').on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, buffer)
        end
      end)
    end,
    opts = { separator = ' ', highlight = false, depth_limit = 5 },
  },
}
