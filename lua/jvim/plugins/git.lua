return {
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    opts = {},
  },

  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    },
  },

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = '<tab>',
          accept_word = false,
          accept_line = false,
        },
      },
      filetypes = {
        help = true,
        markdown = true,
      },
    },
    -- config = function(_, opts)
    --   local client = require('copilot.client')
    --   local command = require('copilot.command')
    --
    --   JVim.register({
    --     { '<leader>lg', function() end, { desc = 'Lazygit' } },
    --     { '<leader>gd', '<cmd>Gvdiffsplit<cr>', { desc = 'Git diff' } },
    --
    --     {
    --       '<leader>cm',
    --       function()
    --         vim.cmd('G add .')
    --         vim.cmd('G commit')
    --       end,
    --       { desc = 'Git commit' },
    --     },
    --
    --     {
    --       '<leader>gco',
    --       function()
    --         if client.is_disabled() then
    --           command.disable()
    --         else
    --           command.enable()
    --         end
    --       end,
    --       desc = { 'Toggle copilot' },
    --     },
    --   })
    --
    --   -- Git
    -- end,
  },
}
