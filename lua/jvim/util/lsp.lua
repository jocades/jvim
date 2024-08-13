local M = {}

---@type vim.diagnostic.Opts
M.diagnostics = {
  underline = true,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
    enabled = true,
  },
  update_in_insert = false,
  severity_sort = true,
}

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

function M.rename_file()
  local buf = vim.api.nvim_get_current_buf()
  local old = vim.api.nvim_buf_get_name(buf)
  local root = assert(vim.uv.cwd())
  assert(old:find(root, 1, true) == 1, 'File not in project root')

  local extra = old:sub(#root + 2)

  vim.ui.input({
    prompt = 'New File Name: ',
    default = extra,
    completion = 'file',
  }, function(new)
    if not new or new == '' or new == extra then
      return
    end
    new = vim.fs.joinpath(root, new)
    vim.fn.mkdir(vim.fs.dirname(new), 'p')
    M.request_rename(old, new, function()
      vim.fn.rename(old, new)
      vim.cmd.edit(new)
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.fn.delete(old)
    end)
  end)
end

---@param from string
---@param to string
---@param rename? fun()
function M.request_rename(from, to, rename)
  local changes = {
    files = {
      {
        oldUri = vim.uri_from_fname(from),
        newUri = vim.uri_from_fname(to),
      },
    },
  }

  local clients = vim.lsp.get_clients()
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
