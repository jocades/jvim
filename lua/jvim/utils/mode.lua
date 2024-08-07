local M = {}

---@class GitSettings
---@field copilot boolean
---@field line_blame boolean
---@field signs boolean

---@class LSPSettings
---@field diagnostics vim.diagnostic.Opts

---@class Mode
---@field git GitSettings
---@field lsp LSPSettings

---@type Mode
local relaxed = {
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
local work = {
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

---@type Mode
---@diagnostic disable-next-line assign-type-missmatch
vim.g = vim.g

local mode = relaxed

function M.toggle()
  if mode == relaxed then
    mode = work
  else
    mode = relaxed
  end
end

function M.reset()
  local copilot = require('copilot.command')
  local gitsigns = require('gitsigns')

  if mode.git.copilot then
    copilot.enable()
  else
    copilot.disable()
  end

  gitsigns.toggle_signs(mode.git.signs)
  gitsigns.toggle_current_line_blame(mode.git.line_blame)
  vim.diagnostic.config(mode.lsp.diagnostics)
end

return M
