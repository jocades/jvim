local function lsp_server()
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.attached_buffers[vim.api.nvim_get_current_buf()] then
      return (vim.o.columns > 100 and "  " .. client.name) or " "
    end
  end
  return "..."
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    return {
      options = {
        theme = "auto",
        globalstatus = true,
        icons_enabled = true,
        disabled_filetypes = {
          statusline = { "dashboard", "lazy", "alpha" },
        },
        component_separators = "|",
        section_separators = { left = "", right = "" },
      },
      extensions = { "lazy", "man", "neo-tree" },
      tabline = {
        lualine_a = { "tabs" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "branch" }, "diff" },
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
          { "filename", path = 1 },
        },
        -- stylua: ignore
        lualine_x = {
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = { fg = "#ff9e64" },
          },
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = { fg = "#ff9e64" },
          },
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          },
        },
        lualine_y = { { "diagnostics", separator = "" }, { lsp_server } },
        lualine_z = { "location", "progress" },
      },
    }
  end,
  config = function(_, opts)
    local lualine = require("lualine")
    lualine.setup(opts)

    local open = false
    lualine.hide({
      place = { "tabline" },
      unhide = open,
    })

    vim.api.nvim_create_autocmd("TabNew", {
      callback = function()
        if not open then
          open = true
          lualine.hide({
            place = { "tabline" },
            unhide = open,
          })
        end
      end,
    })

    vim.api.nvim_create_autocmd("TabClosed", {
      callback = function()
        if open and #vim.api.nvim_list_tabpages() == 1 then
          open = false
          lualine.hide({
            place = { "tabline" },
            unhide = open,
          })
        end
      end,
    })
  end,
}
