local logo = [[
          ██╗██╗   ██╗██╗███╗   ███╗           Z
          ██║██║   ██║██║████╗ ████║       Z
          ██║██║   ██║██║██╔████╔██║    z
     ██   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  z
     ╚█████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
     ――――――――――――――――――――――――――――――――
]]

return {
  {
    "goolord/alpha-nvim",
    enabled = true,
    event = "VimEnter",
    config = function()
      local dashboard = require("alpha.themes.dashboard")

      logo = string.rep("\n", 4) .. logo .. "\n\n"
      dashboard.section.header.val = vim.split(logo, "\n")
    --stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button('f', ' ' .. ' Find file', ':lua JVim.find_files()<cr>'),
      dashboard.button('n', '󱇧 ' .. ' New file', ':ene <BAR> startinsert<cr>'),
      dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles<cr>'),
      dashboard.button('w', '󰈙 ' .. ' Find grep', ':Telescope live_grep<cr>'),
      dashboard.button('g', ' ' .. ' Git panel', ':Neogit<cr>'),
      dashboard.button('s', '󰦛 ' .. ' Restore session', ':lua require("persistence").load()<cr>'),
      dashboard.button('c', ' ' .. ' Config', ':e $MYVIMRC<cr>'),
      dashboard.button('l', '󰒲 ' .. ' Lazy', ':Lazy<cr>'),
      dashboard.button('q', ' ' .. ' Quit', ':qa<cr>'),
    }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = string.format(
            "⚡ Neovim loaded %d/%d plugins in %.2fms",
            stats.loaded,
            stats.count,
            ms
          )
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
