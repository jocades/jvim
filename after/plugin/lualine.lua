local present, lualine = pcall(require, 'lualine')
-- TODO: Add a spaces info
if not present then
  return
end

local function spaces()
  local spaces = vim.api.nvim_buf_get_option(0, 'expandtab') and 'sp' or 'tb'
  local width = vim.api.nvim_buf_get_option(0, 'shiftwidth')
  return string.format('%s: %d', spaces, width)
end

local function lsp_server()
  local msg = 'No Active Lsp'
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name
    end
  end
  return msg
end

lualine.setup {
  options = {
    theme = 'auto',
    globalstatus = true,
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
    -- component_separators = { left = '', right = '' },
    -- section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_b = { 'branch' },
    lualine_c = { 'filename', 'diff' },
    lualine_x = { 'diagnostics' },
    lualine_y = {
      -- lsp_server,
      --'fileformat',
      'filetype',
    },
    lualine_z = { 'location' },
  },
}
