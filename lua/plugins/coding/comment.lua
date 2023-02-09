return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
  config = function()
    require('Comment').setup {
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      opleader = {
        line = '<leader>cc',
        block = '<leader>cb',
      },
      toggler = {
        line = '<leader>cc',
        block = '<leader>cb',
      },
    }
  end,
}
