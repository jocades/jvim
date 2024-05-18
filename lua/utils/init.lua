local api = vim.api

local M = {}

-- Set keymaps with default options
---@param mode string | string[]
---@param keys string
---@param exec string | fun()
---@param opts? table
function M.map(mode, keys, exec, opts)
  local common = { silent = true }
  if not opts then
    opts = common
  else
    table.merge(common, opts)
  end

  vim.keymap.set(mode, keys, exec, opts)
end

-- LSP attach callback helper
---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.buf
      on_attach(client, buffer)
    end,
  })
end

-- Check if file exists
---@param path string
---@return boolean
function M.file_exists(path) return vim.fn.filereadable(path) == 1 end

-- Execute shell command using vim.fn.system
---@param exec string | table { string }
function M.sys(exec, debug)
  if type(exec) == 'table' then exec = table.concat(exec, ' && ') end
  if debug then print(exec) end
  vim.fn.system(exec)
end

-- Execute shell command using lua io.popen and return result
---@param cmd string
function M.shell(cmd)
  local handle = io.popen(cmd)
  if not handle then return nil end
  local result = handle:read('*a')
  handle:close()
  return result
end

return M
