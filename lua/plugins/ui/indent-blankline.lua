return {
  'lukas-reineke/indent-blankline.nvim', -- add indentation guides even on blank lines
  event = 'BufReadPost',
  opts = {
    char = '▏', -- "┊",
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    use_treesitter = true,
    show_current_context = false,
    buftype_exclude = { 'terminal', 'nofile' },
    filetype_exclude = {
      'help',
      'NvimTree',
      'lazy',
      'Trouble',
      'alpha',
    },
  },
}
