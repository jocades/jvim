return {
  'tpope/vim-fugitive', -- git commands in nvim
  'tpope/vim-rhubarb', -- fugitive-companion to interact with github
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    opts = {
      hello = 'world',
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
          -- next = '<C-]>',
          -- prev = '[[',
          -- dismiss = '<C-]>',
        },
      },
      filetypes = {
        help = true,
        markdown = true,
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      --[[ signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      }, ]]
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    },
  },
}
