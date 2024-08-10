return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufEnter',
    dependencies = {
      'williamboman/mason-lspconfig.nvim', -- lspconfig setup (capabilites, on_attach, etc)
      { 'b0o/SchemaStore.nvim', lazy = true, version = false }, -- lsp for common json schemas
      'jose-elias-alvarez/typescript.nvim',
    },
    opts = {
      diagnostics = {
        underline = true,
        virtual_text = { spacing = 4, source = 'if_many', prefix = '●' },
        update_in_insert = false,
        severity_sort = true,
      },
      autoformat = true,
      format = { -- handled by conform.nvim
        formatting_options = nil,
        timeout_ms = nil,
      },
      codelens = {
        enabled = false,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      -- Servers & Settings
      servers = {
        -- Python
        pyright = {
          settings = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              typeCheckingMode = 'basic',
            },
          },
        },
        -- ruff_lsp = {}, -- fast but missing a lof of features, like hover, etc.
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        },
        -- JSON
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas
              or {}
            vim.list_extend(
              new_config.settings.json.schemas,
              require('schemastore').json.schemas()
            )
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
        -- TypeScript
        tsserver = {
          single_file_support = true,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = false,
              },
            },
          },
        },
        --- HTML
        html = {},
        -- CSS
        cssls = {},
        -- Tailwind CSS
        tailwindcss = {},
        -- Astro
        astro = {},
        -- Svelte
        svelte = {},
        -- C
        clangd = {
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed',
            '--header-insertion=iwyu',
          },
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
          },
        },
        -- Go
        gopls = {
          cmd = { 'gopls', 'serve' },
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
            },
          },
        },
        -- Rust
        rust_analyzer = {},
        -- TOML
        taplo = {},
        -- Zig
        zls = {},
        --- Elixir
        elixirls = {
          cmd = { '/Users/j0rdi/.local/share/nvim/mason/bin/elixir-ls' },
          single_file_support = true,
        },
      },
    },
    config = function(_, opts)
      JVim.lsp.on_attach(function(client, e)
        -- vim.notify(e.file, 'warn')
      end)

      vim.diagnostic.config(opts.diagnostics)
      local capabilities = require('cmp_nvim_lsp').default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      capabilities.offsetEncoding = { 'utf-16' } -- fix clang formatter warnings

      local lsp_config = require('mason-lspconfig')

      lsp_config.setup({ ensure_installed = vim.tbl_keys(opts.servers) })

      lsp_config.setup_handlers({
        function(server_name)
          local setup = opts.servers[server_name] or {}
          setup.capabilities = capabilities
          setup.on_attach = require('jvim.plugins.lsp.keymaps').on_attach

          require('lspconfig')[server_name].setup(setup)
        end,
      })

      JVim.map('n', '<leader>dt', function()
        opts.diagnostics.virtual_text = not opts.diagnostics.virtual_text
        vim.diagnostic.config(opts.diagnostics)
      end, 'LSP: Toggle inline text diagnostics')

      JVim.map('n', '<leader>di', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = 'LSP: Toggle inlay hints' })
    end,
  },

  -- LS manager
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ensure_installed = {
        'autopep8',
        'stylua',
        'shellcheck',
        'shfmt',
        'clangd',
        'clang-format',
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
}
