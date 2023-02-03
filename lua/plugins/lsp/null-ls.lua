local present, null_ls = pcall(require, 'null-ls')
if not present then
  return
end

local b = null_ls.builtins

-- Enable the following formatters
local sources = {
  b.formatting.prettierd.with { extra_args = { '--no-semi', '--single-quote' } },
  b.formatting.autopep8, -- Python
  b.formatting.stylua, -- Lua
  b.formatting.shfmt, -- Shell

  b.diagnostics.shellcheck.with { diagnostics_format = '#{m} [#{c}]' },
}

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

local function format(bufnr)
  vim.lsp.buf.format {
    filter = function(client) return client.name == 'null-ls' end,
    bufnr = bufnr,
  }
end

-- Format on save
local function on_attach(client, bufnr)
  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function() format(bufnr) end,
    })
  end
end

vim.api.nvim_create_user_command(
  'DisableLspFormatting',
  function() vim.api.nvim_clear_autocmds { group = augroup, buffer = 0 } end,
  { nargs = 0 }
)

null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = on_attach,
}
