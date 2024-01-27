local api = vim.api

local M = {}

-- Merge 2 or more dictionaries
---@param ... table[]
---@return table
function M.merge(...)
  local result = {}
  for _, t in ipairs({ ... }) do
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

-- LSP attach callback helper
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

-- Check if file exists
---@param path string
---@return boolean
function M.file_exists(path) return vim.fn.filereadable(path) == 1 end

-- Execute shell command
---@param exec string | table { string }
function M.sys(exec, debug)
  if type(exec) == 'table' then
    exec = table.concat(exec, ' && ')
  end
  if debug then
    print(exec)
  end
  vim.fn.system(exec)
end

-- Reduce function for lua tables
---@param tbl table
---@param fn function
---@param initial unknown
function M.reduce(tbl, fn, initial)
  local acc = initial
  for _, value in ipairs(tbl) do
    acc = fn(acc, value)
  end
  return acc
end

return M
