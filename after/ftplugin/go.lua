-- vim.notify("require")
-- require("lib.go-tools.go-test")

vim.keymap.set("n", "<leader>ie", function()
  local win = vim.api.nvim_get_current_win()
  local ln = vim.api.nvim_win_get_cursor(win)[1]
  vim.api.nvim_buf_set_lines(0, ln, ln, false, {
    "if err != nil {",
    "\treturn err",
    "}",
  })
  vim.cmd.normal("jj")
  -- vim.cmd('startinsert!')
end, { desc = "check-error" })
