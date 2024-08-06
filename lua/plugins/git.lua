return {
  {
    'github/copilot.vim',
    -- enabled = false,
    -- event = 'InsertEnter',
  },
  'tpope/vim-fugitive', -- git commands in nvim
  'tpope/vim-rhubarb', -- fugitive-companion to interact with github

  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
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
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    },
  },
}
