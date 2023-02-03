-- Search and replace in multiple files
return {
  'windwp/nvim-spectre',
  keys = {
    { '<leader>sr', function() require('spectre').open() end, desc = 'Replace in files (Spectre)' },
  },
}
