local modes = require('lvim.modes')

local relaxed = modes.relaxed
local work = modes.work

LVim = {
  mode = relaxed,
}

function LVim:toggle()
  if self.mode == relaxed then
    self.mode = work
  else
    self.mode = relaxed
  end

  require('copilot.command').toggle()
  self:reset()
end

function LVim:reset()
  local gitsigns = require('gitsigns')
  gitsigns.toggle_signs(self.mode.git.signs)
  gitsigns.toggle_current_line_blame(self.mode.git.line_blame)
  vim.diagnostic.config(self.mode.lsp.diagnostics)
end

function LVim:diagnostics() return self.mode.lsp.diagnostics end

vim.api.nvim_create_user_command('ModeToggle', function() LVim:toggle() end, {
  desc = 'Toggle editor mode',
})

vim.api.nvim_create_user_command(
  'Test',
  function() require('test').setup() end,
  {}
)
