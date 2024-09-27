---@class JVim: LazyUtil
local M = {
  buf = require("jvim.util.buf"),
  lsp = require("jvim.util.lsp"),
  git = require("jvim.util.git"),
  plugin = require("jvim.util.plugin"),
  toggle = require("jvim.util.toggle"),
  diagnostic = require("jvim.util.diagnostic"),
}

setmetatable(M, { __index = require("lazy.util") })

function M.who()
  vim.system({ "whoami" }, nil, function(proc)
    vim.notify(proc.stdout)
  end)
end

---@param v unknown
---@param title? string
function M.ins(v, title)
  if title then
    vim.print(("==== %s ===="):format(title))
  end
  vim.print(vim.inspect(v))
end

---@param mode string
---@param keys string
---@param exec string|fun()
---@param opts? vim.keymap.set.Opts|string
---@param modify? fun(opts: vim.keymap.set.Opts): nil
function M.map(mode, keys, exec, opts, modify)
  opts = type(opts) == "string" and { desc = opts } or opts or {}
  ---@cast opts vim.keymap.set.Opts
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, keys, exec, modify and modify(opts) or opts)
end

---@param keymaps jvim.Keymaps|[string,string|fun(),string|vim.keymap.set.Opts][]
---@param modify? fun(opts: vim.keymap.set.Opts): nil
function M.register(keymaps, modify)
  if vim.islist(keymaps) then
    for _, t in ipairs(keymaps) do
      M.map("n", t[1], t[2], t[3], modify)
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
    return vim.api.nvim_create_augroup("__jvim", { clear = false })
  end
  return vim.api.nvim_create_augroup("__jvim_" .. name, { clear = true })
end

---@param event string|string[]
---@param opts vim.api.keyset.create_autocmd
---@param name? string
---@return number # The autocmd id
function M.autocmd(event, opts, name)
  opts.group = M.augroup(name)
  return vim.api.nvim_create_autocmd(event, opts)
end

---@param fn fun()
function M.on_very_lazy(fn)
  M.autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name 'autocmds'|'keymaps'|'options'
function M.load(name)
  local mod = "jvim.config." .. name
  return M.try(function()
    return require(mod)
  end, { msg = "Failed loading " .. mod })
end

---Execute a system command (blocking).
---@param cmd string|string[]
function M.exe(cmd)
  if type(cmd) == "string" then
    cmd = vim.split(cmd, " ")
  end
  return vim.system(cmd, { text = true }):wait()
end

function M.find_files()
  if M.git.in_repo then
    require("telescope.builtin").git_files()
  else
    require("telescope.builtin").find_files()
  end
end

---Merge two tables recursively, modifying the first table.
---@param t1 table
---@param t2 table
function M.merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      t1[k] = vim.tbl_deep_extend("force", t1[k] or {}, v)
    else
      t1[k] = v
    end
  end
end

return M
