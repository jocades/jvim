return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = function()
    return {
      options = {
        theme = 'auto',
        globalstatus = true,
        icons_enabled = true,
        disabled_filetypes = {
          statusline = { 'dashboard', 'lazy', 'alpha' },
        },
        section_separators = { left = '', right = '' },
        component_separators = '|',
      },
      sections = {
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            'filetype',
            icon_only = true,
            separator = '',
            padding = { left = 1, right = 0 },
          },
          -- 'filename',
          {
            function()
              local path = vim.fn.expand('%:p')
              return path:gsub(vim.fn.getcwd() .. '/', '')
            end,
          },

          --[[ {
            function() return require('nvim-navic').get_location() end,
            cond = function() return package.loaded['nvim-navic'] and require('nvim-navic').is_available() end,
          }, ]]
        },
        lualine_x = { 'diagnostics' },
        lualine_y = { 'filetype' },
        lualine_z = { 'location', 'progress' },
      },
    }
  end,
}

--[[ local function spaces()
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
end ]]
