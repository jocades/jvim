return {
  'RRethy/vim-illuminate', -- highlight references on cursor hold
  event = 'BufReadPost',
  opts = { delay = 200 },
  config = function(_, opts)
    require('illuminate').configure(opts)
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        pcall(vim.keymap.del, 'n', ']]', { buffer = buf })
        pcall(vim.keymap.del, 'n', '[[', { buffer = buf })
      end,
    })
  end,
  keys = {
    { ']]', function() require('illuminate').goto_next_reference(false) end, desc = 'Next Reference' },
    { '[[', function() require('illuminate').goto_prev_reference(false) end, desc = 'Prev Reference' },
  },
}
