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

function M.hacky_reload()
  require('utils').sys {
    tmux.select_pane('-D'),
    tmux.send_keys { 'C-c', '!!', 'Enter' },
    tmux.select_pane('-U'),
  }
  -- OR
  -- sys('tmux send-keys -t 1 C-c "!!" Enter')
  vim.notify('Service reloaded...', vim.log.levels.DEBUG, { title = 'Reload' })
end

return M
