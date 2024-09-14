local M = {}

function M.diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function M.inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

function M.formatting()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
end

function M.virtual_text()
  if JVim.lsp.diagnostics.virtual_text.enabled then
    local diagnostics = vim.deepcopy(JVim.lsp.diagnostics)
    diagnostics.virtual_text = false
    vim.diagnostic.config(diagnostics)
  else
    vim.diagnostic.config(JVim.lsp.diagnostics)
  end
  ---@diagnostic disable-next-line: inject-field
  JVim.lsp.diagnostics.virtual_text.enabled =
    not JVim.lsp.diagnostics.virtual_text.enabled
end

function M.hlsearch()
  if vim.opt.hlsearch:get() then
    vim.cmd.nohl()
    return ""
  else
    return "<CR>"
  end
end

return M
