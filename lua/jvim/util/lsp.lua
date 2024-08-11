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

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: vim.lsp.Client):boolean}

---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param from string
---@param to string
---@param rename? fun()
function M.on_rename(from, to, rename)
  local changes = {
    files = {
      {
        oldUri = vim.uri_from_fname(from),
        newUri = vim.uri_from_fname(to),
      },
    },
  }

  local clients = M.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method('workspace/willRenameFiles') then
      local resp =
        client.request_sync('workspace/willRenameFiles', changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end

  if rename then
    rename()
  end

  for _, client in ipairs(clients) do
    if client.supports_method('workspace/didRenameFiles') then
      client.notify('workspace/didRenameFiles', changes)
    end
  end
end

return M
