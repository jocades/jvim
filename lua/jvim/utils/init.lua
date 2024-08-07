local LazyUtil = require('lazy.util')

---@class JVim: LazyUtil
local M = {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    return t[k]
    -- t[k] = require('jvim.utils.' .. k)
    -- return t[k]
  end,
  keymap = require('jvim.utils.keymap'),
  log = require('jvim.utils.log'),
  str = require('jvim.utils.str'),
  mode = require('jvim.utils.mode'),
  git = require('jvim.utils.git'),
  lsp = require('jvim.utils.lsp'),
}

function M.diagnostics()
  return vim.deepcopy(M.lsp.diagnostics)
end

local default = { silent = true }

-- Set keymaps with default options
---@param mode string|string[]
---@param keys string
---@param exec string|fun()
---@param opts? table|string
function M.map(mode, keys, exec, opts)
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  table.merge(default, opts or {})
  vim.keymap.set(mode, keys, exec, opts)
end

-- LSP attach callback helper
---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
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
function M.file_exists(path)
  return vim.fn.filereadable(path) == 1
end

-- Execute shell command using vim.fn.system
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

-- Execute shell command using lua io.popen and return result
---@param cmd string
function M.shell(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end
  local result = handle:read('*a')
  handle:close()
  return result
end

return M
