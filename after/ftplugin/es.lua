require('utils').map(
  'n',
  '<leader>ff',
  function() print('Hola amigo!') end,
  { buffer = 0 }
)

vim.opt_local.shiftwidth = 10
