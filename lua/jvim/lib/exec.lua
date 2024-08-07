local sys = require('jvim.utils').sys

local M = {}

local tmux = {
  ---@param pane string
  select_pane = function(pane) return 'tmux select-pane ' .. pane end,

  ---@param keys string[]
  send_keys = function(keys)
    local cmd = 'tmux send-keys '
    for _, key in ipairs(keys) do
      cmd = cmd .. key .. ' '
    end
    return cmd
  end,
}

function M.run_last()
  sys({
    tmux.select_pane('-l'),
    tmux.send_keys({ '!!', 'Enter' }),
    tmux.select_pane('-l'),
  })
end

function M.hacky_reload()
  sys({
    tmux.select_pane('-D'),
    tmux.send_keys({ 'C-c', '!!', 'Enter' }),
    tmux.select_pane('-U'),
  })
  vim.notify('Service reloaded...', vim.log.levels.DEBUG, { title = 'Reload' })
end

---@param opts? table { type: 'v' | 'h' }
function M.new_buf(opts)
  local name = vim.fn.input('Enter file name: ')
  if name == '' then return end
  local path = '%:h/' .. name
  if not opts then
    vim.cmd.e(path)
    return
  end
  if opts.type == 'v' then
    vim.cmd('vsplit' .. path)
  else
    vim.cmd('split' .. path)
  end
end

-- Close all saved buffers
function M.close_saved()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) then
      if not vim.api.nvim_buf_get_option(buf, 'modified') then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end

return M
