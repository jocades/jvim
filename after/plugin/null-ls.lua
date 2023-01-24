local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  }
end

local b = null_ls.builtins

local sources = {
  b.formatting.prettier.with { extra_args = { "--no-semi" } }, -- Typescript
  b.formatting.autopep8, -- Python
  b.formatting.stylua, -- Lua
  b.formatting.shfmt, -- Shell
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup {
  debug = true,
  sources = sources,

  --format on save
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end,
}

vim.api.nvim_create_user_command("DisableLspFormatting", function()
  vim.api.nvim_clear_autocmds { group = augroup, buffer = 0 }
end, { nargs = 0 })
