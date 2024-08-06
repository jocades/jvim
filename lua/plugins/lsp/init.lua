local Path = require('lib.path')
local map = require('utils').map

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufEnter',
    dependencies = {
      'williamboman/mason.nvim', -- automatically install LSPs to stdpath for neovim
      'williamboman/mason-lspconfig.nvim', -- lspconfig setup (capabilites, on_attach, etc)
      { 'j-hui/fidget.nvim', config = true }, -- lsp status UI
      { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
      { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } }, -- additional lua configuration (neovim globals, require paths cmp, etc)
      { 'b0o/SchemaStore.nvim', version = false }, -- lsp for common json schemas
      'jose-elias-alvarez/typescript.nvim',
    },
    opts = {
      diagnostics = LVim:diagnostics(),
      autoformat = true,
      format = {
        formatting_options = nil, -- handled by conform.nvim
        timeout_ms = nil,
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
          on_new_config = function()
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
          -- root_dir = require('lspconfig.util').root_pattern('package.json'),
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
        -- Deno
        --[[ denols = {
          root_dir = require('lspconfig.util').root_pattern('deno.json'),
          init_options = { enable = true, unstable = true },
        }, ]]
        --- HTML
        html = {},
        -- CSS
        cssls = {},
        -- css_variables = {},
        -- Tailwind CSS
        tailwindcss = {},
        -- Astro Framework
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
        -- Zig
        zls = {},
        --- Elixir
        elixirls = {
          cmd = { '/Users/j0rdi/.local/share/nvim/mason/bin/elixir-ls' },
          -- root_dir = require('lspconfig.util').root_pattern('mix.exs'),
          single_file_support = true,
        },
        -- SQL
        sqlls = {},
      },
    },
    config = function(_, opts)
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
          setup.on_attach = require('plugins.lsp.keymaps').on_attach

          require('lspconfig')[server_name].setup(setup)
        end,
      })

      map('n', '<leader>dt', function()
        opts.diagnostics.virtual_text = not opts.diagnostics.virtual_text
        vim.diagnostic.config(opts.diagnostics)
      end, { desc = 'LSP: Toggle inline text diagnostics' })

      map(
        'n',
        '<leader>di',
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,
        { desc = 'LSP: Toggle inlay hints' }
      )
    end,
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    opts = {
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = function(bufnr)
          if
            require('conform').get_formatter_info('ruff_format', bufnr).available
          then
            return { 'ruff_format' }
          else
            return { 'autopep8' }
          end
        end,
        javascript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        html = { { 'prettierd', 'prettier' } },
        lite = { { 'prettierd', 'prettier' } },
        css = { { 'prettierd', 'prettier' } },
        sh = { 'shfmt' },
        c = { 'clang_format' },
        rust = { 'rustfmt' },
        go = { 'gofmt' },
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)

      local f = require('conform').formatters
      f.stylua = {
        prepend_args = {
          '--config-path',
          vim.fn.stdpath('config') .. '/stylua.toml',
        },
      }
      f.clang_format = { prepend_args = { '-style=file' } }
      f.autopep8 = { prepend_args = { '--max-line-length', '80' } }
      f.shfmt = { prepend_args = { '-i', '4' } }
      f.gofmt = { prepend_args = { '-s', '-w', '-tabwidth=4' } }
      f.rustfmt = { prepend_args = { '--config', 'max_width=80' } }

      if not Path.cwd().join('.prettierrc').exists() then
        f.prettierd = {
          prepend_args = {
            '--semi=false',
            '--single-quote',
            '--print-width=80',
            '--end-of-line=lf',
          },
        }
      end
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
        'clangd',
        'clang-format',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
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
    enabled = false,
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
