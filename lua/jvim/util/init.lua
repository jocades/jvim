---@class JVim: LazyUtil
local M = {
  buf = require('jvim.util.buf'),
  lsp = require('jvim.util.lsp'),
  git = require('jvim.util.git'),
  tree = require('jvim.util.tree'),
  toggle = require('jvim.util.toggle'),
}

setmetatable(M, { __index = require('lazy.util') })

function M.who()
  vim.system({ 'whoami' }, nil, function(proc)
    vim.notify(proc.stdout)
  end)
end

---@param mode string|string[]
---@param keys string
---@param exec string|fun()
---@param opts? vim.keymap.set.Opts|string
---@param modify? fun(opts: vim.keymap.set.Opts): nil
function M.map(mode, keys, exec, opts, modify)
  opts = type(opts) == 'string' and { desc = opts } or opts or {}
  ---@cast opts vim.keymap.set.Opts
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, keys, exec, modify and modify(opts) or opts)
end

---@param keymaps jvim.Keymaps|[string,string|fun(),vim.keymap.set.Opts|string][]
---@param modify? fun(opts: vim.keymap.set.Opts): nil
function M.register(keymaps, modify)
  if vim.islist(keymaps) then
    for _, t in ipairs(keymaps) do
      M.map('n', t[1], t[2], t[3], modify)
    end
  else
    ---@cast keymaps jvim.Keymaps
    for mode, mappings in pairs(keymaps) do
      for k, t in pairs(mappings) do
        M.map(mode, k, t[1], t[2], modify)
      end
    end
  end
end

---@param name? string
function M.augroup(name)
  if not name then
    return vim.api.nvim_create_augroup('__jvim', { clear = false })
  end
  return vim.api.nvim_create_augroup('__jvim_' .. name, { clear = true })
end

---@param event string|string[]
---@param opts vim.api.keyset.create_autocmd
---@param name? string
function M.autocmd(event, opts, name)
  opts.group = M.augroup(name)
  return vim.api.nvim_create_autocmd(event, opts)
end

---@param fn fun()
function M.on_very_lazy(fn)
  M.autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      fn()
    end,
  })
end

---@param name 'autocmds' | 'keymaps' | 'options'
function M.load(name)
  local mod = 'jvim.config.' .. name
  return M.try(function()
    return require(mod)
  end, { msg = 'Failed loading ' .. mod })
end

return M
