local present, lualine = pcall(require, "lualine")

if not present then
  return
end

lualine.setup {
  options = {
    icons_enabled = false,
    theme = "onedark",
    -- component_separators = '|',
    -- section_separators = '',
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_b = { "branch" },
    lualine_c = { "buffers" },
    lualine_x = { "diff", "diagnostics" },
    lualine_y = { "filetype" },
  },
}
