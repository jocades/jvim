local M = {}

function M.modified()
  return vim.tbl_filter(function(buf)
    return vim.bo[buf].modified
  end, vim.api.nvim_list_bufs())
end

---@param buf number?
function M.remove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(
      ("Save changes to %q?"):format(vim.fn.bufname()),
      "&Yes\n&No\n&Cancel"
    )
    if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if
        not vim.api.nvim_win_is_valid(win)
        or vim.api.nvim_win_get_buf(win) ~= buf
      then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious") ---@diagnostic disable-line
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf) ---@diagnostic disable-line
  end
end

function M.new()
  vim.ui.input({ prompt = "Enter file name: " }, function(input)
    if not input or vim.trim(input) == "" then
      return
    end
    vim.cmd.e("%:h/" .. input)
  end)
end

function M.close_all()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    vim.print(vim.api.nvim_buf_get_name(buf))
    M.remove(buf)
  end
end

-- vim.tbl_map(function(buf)
--   vim.print(vim.api.nvim_buf_get_name(buf))
-- end, vim.api.nvim_list_bufs())

return M
