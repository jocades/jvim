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

return M
