local cmd = vim.cmd

local M = {}

M.map = function(mode, keys, exec, opts)
  local common = { silent = true, noremap = true }

  if not opts then
    opts = common
  else
    vim.tbl_extend('force', opts, common)
  end

  vim.keymap.set(mode, keys, exec, opts)
end

---@param on_attach fun(client, buffer)
M.on_attach = function(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param opts? table { type: 'v' | 'h' }
M.handle_new_buf = function(opts)
  ---@diagnostic disable-next-line
  local name = vim.fn.input 'Enter file name: '
  if name == '' then
    return
  end

  local path = '%:h/' .. name

  if not opts then
    cmd.e(path)
    return
  end

  if opts.type == 'v' then
    cmd('vsplit' .. path)
  else
    cmd('split' .. path)
  end
end

M.close_all = function()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    local modified = vim.api.nvim_buf_get_option(buf, 'modified')
    if not modified then
      vim.cmd('Bdelete ' .. buf)
    end
  end
end

return M
