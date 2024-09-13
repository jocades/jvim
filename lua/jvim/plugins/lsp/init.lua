return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason-lspconfig.nvim', -- lspconfig setup bridge
      { 'b0o/SchemaStore.nvim', lazy = true, version = false }, -- json/yaml schemas
      'jose-elias-alvarez/typescript.nvim',
    },
    ---@class jvim.LspOpts
    opts = {
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
        offsetEncoding = { 'utf-16' }, -- fix clang formatter warnings
      },
      -- Servers & Settings
      servers = {
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
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              version = 'LuaJIT',
              workspace = { checkThirdParty = false },
              codeLens = { enable = true },
              hint = { enable = true },
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
        -- JSON
        jsonls = {
          on_new_config = function(new_config) -- lazy load schemas
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
        --- Elixir
        elixirls = {
          cmd = { '/Users/j0rdi/.local/share/nvim/mason/bin/elixir-ls' },
          single_file_support = true,
        },
        -- Shell
        bashls = {
          filetype = { 'sh', 'zsh' },
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
        -- TOML
        taplo = {},
        -- Zig
        zls = {},
      },
    },
    ---@param opts jvim.LspOpts
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      local capabilities = JVim.lsp.capabilities(opts)

      for server, config in pairs(opts.servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        automatic_installation = {
          exclude = { 'rust_analyzer', 'zls' },
        },
      })

      JVim.lsp.on_attach(function(client, e)
        require('jvim.plugins.lsp.keymaps').on_attach(client, e.buf)
      end)

      vim.diagnostic.config(JVim.lsp.diagnostics)
    end,
  },

  -- LS + tooling manager
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ensure_installed = {
        'autopep8',
        'clang-format',
        'clangd',
        'shellcheck',
        'shfmt',
        'stylua',
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
