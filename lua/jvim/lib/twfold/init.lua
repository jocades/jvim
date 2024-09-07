local M = {}

local ns = vim.api.nvim_create_namespace('class_conceal')
local group = vim.api.nvim_create_augroup('class_conceal', { clear = true })

local state = {
  bufs = {}, -- buf: marks
  char = '…',
  highlight = {
    fg = '#38BDF8',
  },
}

function M.conceal(buf)
  local tree = vim.treesitter.get_parser(buf, 'tsx'):parse()[1]
  local root = tree:root()

  local query = vim.treesitter.query.parse(
    'tsx',
    ([[
    ((jsx_attribute 
      (property_identifier) @name (#any-of? @name "class" "className")
      (string (string_fragment) @value) (#set! @value conceal "%s")))
    ]]):format(state.char)
  )

  for id, node, metadata, _ in query:iter_captures(root, buf) do
    local capture = query.captures[id]

    if capture == 'value' then
      local srow, scol, erow, ecol = node:range()

      if not state.bufs[buf] then
        state.bufs[buf] = {}
      end

      table.insert(
        state.bufs[buf],
        vim.api.nvim_buf_set_extmark(buf, ns, srow, scol, {
          end_line = erow,
          end_col = ecol,
          conceal = metadata[2].conceal,
          hl_group = 'Twf',
          priority = 0,
        })
      )
    end
  end
end

function M.unconceal(buf)
  for _, id in ipairs(state.bufs[buf]) do
    vim.api.nvim_buf_del_extmark(buf, ns, id)
  end
  state.bufs[buf] = nil
end

function M.setup()
  vim.api.nvim_create_user_command('Twf', function()
    if vim.bo.ft ~= 'typescriptreact' then
      JVim.error('Not a html/jsx file', { title = 'Treesitter' })
      return
    end

    local buf = vim.api.nvim_get_current_buf()

    if state.bufs[buf] then
      M.unconceal(buf)
    else
      M.conceal(buf)
    end
  end, {})

  vim.api.nvim_set_hl(0, 'Twf', state.highlight)

  --[[ vim.api.nvim_create_autocmd(
    { 'BufEnter', 'BufWritePost', 'TextChanged', 'InsertLeave' },
    {
      group = group,
      pattern = '*.tsx',
      callback = function()
        M.conceal_tw_class(vim.api.nvim_get_current_buf())
      end,
    }
  ) ]]
end

M.setup()

return M
