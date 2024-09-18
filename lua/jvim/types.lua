---@meta

---@class JVimOpts
---@field colorscheme? string
---@field dev? string

---@generic T: vim.keymap.set.Opts|string
---@alias jvim.Keymap table<string, [string|fun(), T]>

---@class jvim.Keymaps
---@field n? jvim.Keymap
---@field i? jvim.Keymap
---@field v? jvim.Keymap

_G.JVim = require("jvim.util")
