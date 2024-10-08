local prettier = {
  opts = { "prettierd", "prettier", stop_after_first = true },
  args = {
    "--semi=false",
    "--single-quote",
    "--print-width=80",
    "--end-of-line=lf",
  },
}

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  ---@moudle 'conform'
  ---@type conform.setupOpts
  opts = {
    format_on_save = function(buf)
      if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      c = { "clang_format" },
      sh = { "shfmt" },
      python = { "ruff_format" },
      javascript = prettier.opts,
      javascriptreact = prettier.opts,
      typescript = prettier.opts,
      typescriptreact = prettier.opts,
      json = prettier.opts,
      html = prettier.opts,
      css = prettier.opts,
      go = { "gofmt" },
      asm = { "asmfmt" },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)
    local f = require("conform").formatters
    f.stylua = {
      prepend_args = {
        "--config-path",
        vim.fs.joinpath(
          vim.fn.stdpath("config") --[[@as string]],
          "stylua.toml"
        ),
      },
    }
    f.clang_format = { prepend_args = { "-style=file" } }
    f.autopep8 = { prepend_args = { "--max-line-length", "80" } }
    f.shfmt = { prepend_args = { "-i", "4" } }
    f.gofmt = { prepend_args = { "-s" } }
    f.rustfmt = { prepend_args = { "--config", "max_width=100" } }

    if not JVim.file_exists(vim.fs.joinpath(vim.uv.cwd(), ".prettierrc")) then
      f.prettierd = { prepend_args = prettier.args }
      f.prettier = { prepend_args = prettier.args }
    end

    -- Enable / disable autoformatting on save
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- `FromatDisable!` to disable for current buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformatting on save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Enable autoformatting on save",
    })
  end,
}
