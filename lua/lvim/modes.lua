---@class GitSettings
---@field copilot boolean
---@field line_blame boolean
---@field signs boolean

---@class LSPSettings
---@field diagnostics { virtual_text: boolean|{ spacing: number, prefix: string } }

---@class Mode
---@field git { copilot: boolean, line_blame: boolean, signs: boolean }
---@field lsp LSPSettings

local M = {}

---@type Mode
M.relaxed = {
  git = {
    copilot = false,
    line_blame = false,
    signs = false,
  },
  lsp = {
    diagnostics = {
      underline = true,
      virtual_text = false,
      update_in_insert = false,
      severity_sort = true,
    },
  },
}

---@type Mode
M.work = {
  git = {
    copilot = true,
    line_blame = true,
    signs = true,
  },
  lsp = {
    diagnostics = {
      underline = true,
      virtual_text = { spacing = 4, prefix = '●' },
      update_in_insert = false,
      severity_sort = true,
    },
  },
}

return M
