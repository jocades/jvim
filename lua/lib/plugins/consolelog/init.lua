local tsu = require('nvim-treesitter.ts_utils')
local event = require('nui.utils.autocmd').event

local M = {}

local loggers = {
  typescript = 'console.log',
  typescriptreact = 'console.log',
  python = 'print',
  lua = 'print',
}

-- get the nodes text and the cursor position
-- capture the current node text and log it to the console
-- after the current 'parent node' insert a new line and log the parent node
-- i.e:
-- local loggers = {
--  typescript = 'console.log',
--  python = 'print',
-- }
-- if the cursros is in 'loggers':
-- then go to the end of the variable declaration and insert a new line so it looks like:
-- local loggers = {
-- typescript = 'console.log',
-- python = 'print',
-- }
-- print('loggers:', loggers)

local function test() print('test') end

function M.test() print('test') end

M.prop = 'prop'

---@param node TSNode
local function lua_is_definition(node)
  return table.includes(
    { 'variable_declaration', 'function_declaration', 'assignment_statement' },
    node:type()
  )
end

---@param node TSNode
M.lua_def = function(node)
  while node and not lua_is_definition(node) do
    print('Node:', node:type())
    node = node:parent()
  end

  print('Def:', node:type())

  local end_line = node:end_()

  return end_line, node:type() == 'function_declaration'
end

M.log = function()
  local ft = vim.bo.filetype
  print('Logging', ft, loggers[ft])

  local node = tsu.get_node_at_cursor()

  if not node then
    print('No node found')
    return
  end

  print('TYPE:', node:type())

  if node:type() ~= 'identifier' then
    print('Not an identifier')
    return
  end

  local text = tsu.get_node_text(node)[1]
  local logger = loggers[ft]

  if not logger then
    print('No logger found for', ft)
    return
  end

  local log = string.format("%s('%s:', %s)", logger, text, text)
  local buf = vim.api.nvim_get_current_buf()

  local line, is_func = nil, false

  if ft == 'lua' then
    line, is_func = M.lua_def(node)
  end

  if is_func then
    log = string.format("%s('%s:', %s())", logger, text, text)
  end

  vim.api.nvim_buf_set_lines(buf, line + 1, line + 1, false, { log })

  if ft == 'python' then
    -- TODO: implement
  end

  if ft == 'typescript' or ft == 'typescriptreact' then
    -- TODO: implement
  end
end

vim.keymap.set(
  'n',
  '<leader>cl',
  function() M.log() end,
  { noremap = true, silent = true }
)

return M
