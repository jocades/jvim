local present, blank_line = pcall(require, 'indent_blankline')

if not present then
  return
end

-- See `:help indent_blankline.txt`
blank_line.setup {
  char = '▏', -- "┊",
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  use_treesitter = true,
  show_current_context = false,
  buftype_exclude = { 'terminal', 'nofile' },
  filetype_exclude = {
    'help',
    'packer',
    'NvimTree',
  },
}
