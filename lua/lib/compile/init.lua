local M = {}

local s = {
  buf = -1,
  win = -1,
}

function M.execute()
  local cmd = {
    "clang",
    "-std=c99",
    "-Wall",
    "-Wextra",
    "-fcolor-diagnostics",
    "-fansi-escape-codes",
  }
  local input = vim.api.nvim_buf_get_name(0)
  local output = vim.fn.fnamemodify(input, ":r")
  table.insert(cmd, "-o")
  table.insert(cmd, output)
  table.insert(cmd, input)

  vim.system(cmd, { text = true }, function(p)
    if not p.stderr then
      return
    end
    vim.schedule(function()
      if s.buf == -1 then
        s.buf = vim.api.nvim_create_buf(false, true)
        vim.cmd.split()
        s.win = vim.api.nvim_get_current_win()
        vim.keymap.set("n", "q", function()
          vim.cmd.quit()
          s.buf = -1
          s.win = -1
        end, { buffer = s.buf })
        vim.print(s)
      end
      vim.api.nvim_buf_set_lines(s.buf, 0, -1, true, vim.split(p.stderr, "\n"))
      -- vim.api.nvim_set_current_win(s.win)
      -- vim.api.nvim_set_current_buf(s.buf)
    end)
  end)

  --[[ local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "Some", "line", "one", "two" })
  vim.bo[buf].modifiable = false
  vim.keymap.set("n", "q", vim.cmd.q, { buffer = buf })

  vim.cmd.split()
  vim.api.nvim_set_current_buf(buf) ]]
end

vim.api.nvim_create_user_command("Compile", M.execute, {})

return M
