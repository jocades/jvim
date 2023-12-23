-- how to pass args to a user commnad?
vim.api.nvim_create_user_command('How', function(opts) P(opts) end, {
  nargs = '?',
})
