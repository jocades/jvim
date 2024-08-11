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
  },
}
