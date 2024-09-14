local M = {}

---@param pane string
function M.select_pane(pane)
  return "tmux select-pane " .. pane
end

---@param keys string[]
function M.send_keys(keys)
  return "tmux send-keys " .. table.concat(keys, " ")
end

---@param cmd string[]
function M.run(cmd)
  return ("tmux send-keys %s Enter"):format(table.concat(cmd, "\\ "))
end

return M
