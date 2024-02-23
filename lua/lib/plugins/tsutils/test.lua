local ts_utils = require('nvim-treesitter.ts_utils')

-- trying out ts utils

local M = {}

local function get_node_at_cursor()
  local node = ts_utils.get_node_at_cursor()
  if not node then
    error('No node found')
  end
  return node
end

local function main()
  local node = get_node_at_cursor()

  local buf = vim.api.nvim_get_current_buf()
  ts_utils.update_selection(buf, node)
end

vim.keymap.set('n', 'x', main, { noremap = true })

return M
