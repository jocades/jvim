-- vim.notify('hello!')

-- vim.ui.input(
--   { prompt = 'Enter value for shiftwidth: ' },
--   function(input) vim.o.shiftwidth = tonumber(input) end
-- )

-- vim.ui.select({ 'tabs', 'spaces' }, {
--   prompt = 'Select tabs or spaces:',
--   format_item = function(item)
--     return "I'd like to choose " .. item
--   end,
-- }, function(choice)
--   if choice == 'spaces' then
--     vim.o.expandtab = true
--   else
--     vim.o.expandtab = false
--   end
-- end)

---@type vim.lsp.Client
local client = vim.lsp.get_clients({
  name = 'lua_ls',
  bufnr = 0,
  -- method = 'workspace/willRenameFiles',
})[1]

local will = 'workspace/willRenameFiles'
local did = 'workspace/didRenameFiles'

-- print(client.supports_method(method))

local old = vim.api.nvim_buf_get_name(0)
local new = vim.fs.joinpath(vim.fs.dirname(old), 'other.lua')
-- vim.print({
--   old = old,
--   new = new,
-- })

local changes = {
  files = {
    {
      oldUri = vim.uri_from_fname(old),
      newUri = vim.uri_from_fname(new),
    },
  },
}
-- vim.print(changes)

print('client', client.supports_method('workspace/didRename'))

print(
  'server',
  not not client.server_capabilities.workspace.fileOperations.didRename
)

JVim.lsp.rename_file()
-- local res = client.notify(did, changes)

--
-- vim.print(res)
-- if res and res.err then
--   print(res.err)
-- end

--[[ for _, client in
  ipairs(vim.lsp.get_clients({
    name = 'lua_ls',
    bufnr = 0,
    -- method = 'workspace/willRenameFiles',
  }))
do
  if client.supports_method(method) then
    print('supports_method', method)
    local res = client.request_sync(method, changes, 1000, 0)
    vim.print(res)
    if res and res.err then
      print(res.err)
    end
  end
end ]]

-- JVim.lsp.rename_file(function(changes)
--   vim.print(changes)
--   if client.supports_method(method) then
--     print('supports_method', method)
-- local res = client.request_sync(method, changes, 1000, 0)
--     vim.print(res)
--     if res and res.err then
--       print(res.err)
--     end
--   end
-- end)

-- print(client.supports_method('workspace/willRenameFiles'))
-- -- vim.print('ehl')
-- print(client.supports_method('workspace/didRenameFiles'))

-- client.request_sync('workspace/willRenameFiles')
