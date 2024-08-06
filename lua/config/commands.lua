vim.api.nvim_create_user_command('ModeToggle', function() LVim:toggle() end, {
  desc = 'Toggle editor mode',
})

-- Enable / disable autoformatting on save
vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- `FromatDisable!` to disable for current buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformatting on save',
  bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Enable autoformatting on save',
})
