local M = {}

local ns = vim.api.nvim_create_namespace('class_conceal')
local group = vim.api.nvim_create_augroup('class_conceal', { clear = true })

local ids = {}

function M.conceal_tw_class(buf)
  local tree = vim.treesitter.get_parser(buf, 'tsx'):parse()[1]
  local root = tree:root()

  local query = vim.treesitter.query.parse(
    'tsx',
    [[
    ((jsx_attribute 
      (property_identifier) @name (#any-of? @name "class" "className")
      (string (string_fragment) @value) (#set! @value conceal "…")))
    ]]
  )

  for id, node, metadata, _ in query:iter_captures(root, buf) do
    local name = query.captures[id]
    if name == 'value' then
      local srow, scol, erow, ecol = node:range()
      table.insert(
        ids,
        vim.api.nvim_buf_set_extmark(buf, ns, srow, scol, {
          end_line = erow,
          end_col = ecol,
          conceal = metadata[2].conceal,
        })
      )
    end
  end
end

function M.unconceal(buf)
  for _, id in ipairs(ids) do
    vim.api.nvim_buf_del_extmark(buf, ns, id)
  end

  ids = {}
end

function M.setup()
  vim.keymap.set('n', 'tc', function()
    if vim.bo.ft ~= 'typescriptreact' then
      JVim.error('Not a html/jsx file', { title = 'Treesitter' })
      return
    end

    M.conceal_tw_class(vim.api.nvim_get_current_buf())
  end)

  vim.api.nvim_create_user_command('Twf', function()
    if #ids > 1 then
      vim.notify(vim.print('unconceal', ids))
      M.unconceal(vim.api.nvim_get_current_buf())
    end
  end, {})
end

M.setup()

return M
