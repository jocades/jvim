local present, lualine = pcall(require, 'lualine')

if not present then
  return
end

lualine.setup {
  options = {
    theme = 'auto',
    globalstatus = true,
    icons_enabled = true,
    -- component_separators = "|",
    -- section_separators = "",
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'diff', 'diagnostics' },
    lualine_y = { 'filetype' },
  },
}
