local ts_utils = require('nvim-treesitter.ts_utils')

local M = {}

function M.find_inline_links(bufnr)
  local buf = bufnr or vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(buf, 'markdown')
  if not parser then
    print('No parser found for markdown')
    return
  end
  local root = parser:parse()[1]:root()
  local inline_links = {}
  for node in root:iter_children() do
    if node:type() == 'inline_link' then
      table.insert(inline_links, node)
    end
  end
  return inline_links
end

---@param node TSNode
function M.get_inline_link_text(node)
  local text = ''
  for child in node:iter_children() do
    if child:type() == 'text' then
      text = text .. ts_utils.get_node_text(child)[1]
    end
  end
  return text
end

--- get all the inline links and return a list of their text
function M.get_inline_links_text(bufnr)
  local links = M.find_inline_links(bufnr)
  P(links)
  if not links then
    print('No inline links found')
    return
  end
  local links_text = {}
  for _, link in ipairs(links) do
    table.insert(links_text, M.get_inline_link_text(link))
  end
  return links_text
end

vim.keymap.set('n', 't', function()
  local buf = vim.api.nvim_get_current_buf()
  local links = M.get_inline_links_text(buf)
  P(links)
end, { expr = true })

return M
