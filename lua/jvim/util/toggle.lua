local M = {}

---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)

  if not plugin then
    return {}
  end

  local Plugin = require('lazy.core.plugin')
  return Plugin.values(plugin, 'opts', false)
end

function M.diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function M.virtual_text()
  local opts = M.opts('nvim-lspconfig')
  opts.diagnostics.virtual_text = not opts.diagnostics.virtual_text
  vim.diagnostic.config(opts.diagnostics)
end

function M.inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

return M
