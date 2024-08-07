local map = require('jvim.utils').map
local modes = require('jvim.modes')

local relaxed = modes.relaxed
local work = modes.work

JVim = {
  mode = relaxed,
}

function JVim:toggle()
  if self.mode == relaxed then
    self.mode = work
  else
    self.mode = relaxed
  end
end

function JVim:reset()
  local copilot = require('copilot.command')
  local gitsigns = require('gitsigns')

  if self.mode.git.copilot then
    copilot.enable()
  else
    copilot.disable()
  end

  gitsigns.toggle_signs(self.mode.git.signs)
  gitsigns.toggle_current_line_blame(self.mode.git.line_blame)
  vim.diagnostic.config(self.mode.lsp.diagnostics)
end

function JVim:diagnostics() return vim.deepcopy(self.mode.lsp.diagnostics) end

---@generic T: vim.keymap.set.Opts|string
---@alias jvim.Keymap table<string, [string|fun(), T]>

---@class jvim.Keymaps
---@field n? jvim.Keymap
---@field i? jvim.Keymap
---@field v? jvim.Keymap

---@generic T
---@param mode string
---@param keymaps jvim.Keymap<T>[]
---@param modifier? fun(opts: T): vim.keymap.set.Opts
local function register(mode, keymaps, modifier)
  for k, v in pairs(keymaps) do
    local opts = type(v[2]) == 'string' and { desc = v[2] } or v[2]
    vim.keymap.set(mode, k, v[1], modifier and modifier(opts) or opts)
  end
end

---@param keymaps jvim.Keymaps | jvim.Keymap[]
function JVim:register(keymaps, modifier)
  if keymaps.n or keymaps.i or keymaps.v then
    for mode, mappings in pairs(keymaps) do
      register(mode, mappings, modifier)
    end
  else
    register('n', keymaps)
  end
end
