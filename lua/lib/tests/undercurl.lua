-- this line contains overlapping diagnostics

local ns = vim.api.nvim_create_namespace("test_namespace")
vim.diagnostic.set(ns, 0, {
  {
    lnum = 0,
    col = 10,
    end_col = 40,
    severity = vim.diagnostic.severity.ERROR,
    message = "error",
    float = {
      header = "HEADERAAA",
      ---@param diag vim.Diagnostic
      format = function(diag)
        return "this is the text"
      end,
    },
  },
  {
    lnum = 0,
    col = 15,
    end_col = 30,
    severity = vim.diagnostic.severity.WARN,
    message = "warning",
  },
})

-- vim.cmd([[
-- hi DiagnosticUnderlineError guisp='Red' gui=underline
-- hi DiagnosticUnderlineWarn guisp='Cyan' gui=undercurl
-- " set termguicolors
-- ]])
