local cmd = vim.cmd
local api = vim.api

local M = {}

-- Merge 2 or more dictionaries
---@param ... table[]
---@return table
function M.merge(...)
  local result = {}
  for _, t in ipairs { ... } do
    for k, v in pairs(t) do
      result[k] = v
    end
  end
  return result
end

-- Set keymaps with default options
---@param mode string
---@param keys string
---@param exec string | function
---@param opts? table
function M.map(mode, keys, exec, opts)
  local common = { silent = true, noremap = true }
  if not opts then
    opts = common
  else
    M.merge(common, opts)
  end

  vim.keymap.set(mode, keys, exec, opts)
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param opts? table { type: 'v' | 'h' }
function M.handle_new_buf(opts)
  local name = vim.fn.input('Enter file name: ')
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

-- Close all saved buffers
function M.close_saved()
  local bufs = api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if api.nvim_buf_is_loaded(buf) then
      if not api.nvim_buf_get_option(buf, 'modified') then
        api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = api.nvim_buf_get_name(0)
  path = path ~= '' and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws) return vim.uri_to_fname(ws.uri) end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b) return #a > #b end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

function M.file_exists(path)
  if vim.fn.filereadable(path) == 1 then
    return true
  end

  return false
end

-- local cwd = vim.fn.getcwd()
-- print(cwd)

-- local files = require('plenary.scandir').scan_dir(vim.fn.getcwd())
-- print(vim.inspect(fojkujkujkles))

--[[ local file = M.get_root() .. '/init.lua'
print(file)

if not M.file_exists(file) then
  print('file exists')
end

local t = { 'a', 'b', 'c' }

table.insert(t, 'd')
P(t) ]]

return M
