local M = {}

---@class LspAttachEvent
---@field buf number Buffer id
---@field data { client_id: number }
---@field event string Event name
---@field file string Absolute file path
---@field id number

---@param fn fun(client: vim.lsp.Client, e: LspAttachEvent)
---@return number # The autocmd id
function M.on_attach(fn)
  return vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then
        JVim.warn({ 'No client found', e.file }, { title = 'LSP' })
        return
      end
      fn(client, e)
    end,
  })
end

function M.capabilities(opts)
  return vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities(),
    opts.capabilities or {}
  )
end

function M.diagnostic_goto(next, severity)
  local go_to = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go_to({ severity = severity })
  end
end

return M
