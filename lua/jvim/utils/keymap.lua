local M = {}

---@generic T: vim.keymap.set.Opts|string
---@alias jvim.Keymap table<string, [string|fun(), `T`]>

---@class jvim.Keymaps
---@field n? jvim.Keymap
---@field i? jvim.Keymap
---@field v? jvim.Keymap

---@generic T
---@param mode string
---@param keymaps jvim.Keymap<`T`>[]
---@param modifier? fun(opts: `T`): vim.keymap.set.Opts
local function register(mode, keymaps, modifier)
  for k, v in pairs(keymaps) do
    local opts = type(v[2]) == 'string' and { desc = v[2] } or v[2]
    vim.keymap.set(mode, k, v[1], modifier and modifier(opts) or opts)
  end
end

---@param keymaps jvim.Keymaps | jvim.Keymap[]
function M.register(keymaps, modifier)
  if keymaps.n or keymaps.i or keymaps.v then
    for mode, mappings in pairs(keymaps) do
      register(mode, mappings, modifier)
    end
  else
    register('n', keymaps)
  end
end

return M
