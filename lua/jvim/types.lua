---@meta

---@class JVimOptions
---@field colorscheme? string
---@field dev? string

---@generic T: vim.keymap.set.Opts|string
---@alias jvim.Keymap table<string, [string|fun(), T]>

---@class jvim.Keymaps
---@field n? jvim.Keymap
---@field i? jvim.Keymap
---@field v? jvim.Keymap

_G.JVim = require('jvim.util')
_G.vim = vim -- for treesitter highlights

--[[
(surround_words) 
"make strings               ys$"            "make strings""
[delete ar*ound me!]        ds]             delete around me!
remove <b>HTML t*ags</b>    dst             remove HTML tags
'change quot*es'            cs'"            "change quotes"
<b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
delete(functi*on calls)     dsf             function calls
]]
