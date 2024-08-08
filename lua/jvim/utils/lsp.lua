local M = {
  diagnostics = {
    underline = true,
    virtual_text = { spacing = 4, source = 'if_many', prefix = '●' },
    update_in_insert = false,
    severity_sort = true,
  },
}

---@class LspAttachEvent
---@field buf number Buffer id
---@field data { client_id: number }
---@field event string Event name
---@field file string Absolute file path
---@field id number

---@param on_attach fun(client: vim.lsp.Client, e: LspAttachEvent)
---@return number # The autocmd id
function M.on_attach(on_attach)
  return vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
      -- vim.notify('Attached')
      -- vim.notify(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)

      if not client then
        vim.notify('No client found for LSP attach event')
        return
      end

      on_attach(client, e)
    end,
  })
end

return M
