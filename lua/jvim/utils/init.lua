local LazyUtil = require('lazy.util')

---@class JVim: LazyUtil
local M = {
  __index = function(t, k)
    if LazyUtil[k] then
      vim.notify('using lazy util')
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

-- Just testing vim.notify
function M.who()
  vim.system({ 'whoami' }, nil, function(o)
    vim.notify(o.stdout)
  end)
end

function M.diagnostics()
  return vim.deepcopy(M.lsp.diagnostics)
end

local default = { silent = true }

---Set keymaps with default options
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

-- Check if file exists
---@param path string
---@return boolean
function M.file_exists(path)
  return vim.fn.filereadable(path) == 1
end

return M
