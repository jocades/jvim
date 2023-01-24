local present, blank_line = pcall(require, "indent_blankline")

if not present then
  return
end

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
blank_line.setup {
  char = "┊",
  show_trailing_blankline_indent = false,
}
