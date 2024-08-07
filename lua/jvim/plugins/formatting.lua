return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
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

    if not require('jvim.lib.path').cwd().join('.prettierrc').exists() then
      f.prettierd = {
        prepend_args = {
          '--semi=false',
          '--single-quote',
          '--print-width=80',
          '--end-of-line=lf',
        },
      }
    end

    -- Enable / disable autoformatting on save
    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- `FromatDisable!` to disable for current buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformatting on save',
      bang = true,
    })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Enable autoformatting on save',
    })
  end,
}
