local M = {}

---@type vim.diagnostic.Opts
M.opts = {
  underline = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
    enabled = true, -- extra field for toggling
  },
  update_in_insert = false,
  severity_sort = true,
}

---@param severity vim.diagnostic.Severity|nil
function M.open(severity)
  return function()
    require("trouble").open({
      mode = "diagnostics",
      filter = { severity = vim.diagnostic.severity[severity] },
      -- filter = { severity}
    })
  end
end

---@param severity vim.diagnostic.Severity|nil
function M.open_buf(severity)
  return function()
    require("trouble").open({
      mode = "diagnostics",
      filter = { buf = 0, severity = vim.diagnostic.severity[severity] },
    })
  end
end

---@param next boolean
---@param severity vim.diagnostic.Severity|nil
function M.go_to(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
