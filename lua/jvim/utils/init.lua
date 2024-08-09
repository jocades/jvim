---@class JVim: LazyUtil
local M = {
  buf = require('jvim.utils.buf'),
  log = require('jvim.utils.log'),
  lsp = require('jvim.utils.lsp'),
}

setmetatable(M, { __index = require('lazy.util') })

-- Just testing vim.notify
function M.who()
  vim.system({ 'whoami' }, nil, function(proc)
    print(proc.stdout)
  end)
end

---@param mode string|string[]
---@param keys string
---@param exec string|fun()
---@param opts? vim.keymap.set.Opts|string
---@param modify? fun(opts: vim.keymap.set.Opts)
function M.map(mode, keys, exec, opts, modify)
  opts = type(opts) == 'string' and { desc = opts } or opts or {}
  ---@cast opts vim.keymap.set.Opts
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, keys, exec, modify and modify(opts) or opts)
end

---@param keymaps jvim.Keymaps|[string,string|fun(),vim.keymap.set.Opts|string][]
---@param modify? fun(opts: vim.keymap.set.Opts)
function M.register(keymaps, modify)
  if vim.islist(keymaps) then
    for _, t in ipairs(keymaps) do
      M.map('n', t[1], t[2], t[3], modify)
    end
  else
    ---@cast keymaps jvim.Keymaps
    for mode, mappings in pairs(keymaps) do
      for k, v in pairs(mappings) do
        M.map(mode, k, v[1], v[2], modify)
      end
    end
  end
end

return M
