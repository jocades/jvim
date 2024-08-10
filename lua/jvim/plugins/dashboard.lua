return {
  {
    'goolord/alpha-nvim',
    enabled = true,
    event = 'VimEnter',
    config = function()
      local dashboard = require('alpha.themes.dashboard')
      -- dynamic header padding
      --[[ local fn = vim.fn
    local marginTopPercent = 0.3 ]]
      -- local headerPadding = fn.max { 2, fn.floor(fn.winheight(0) * marginTopPercent) }

      local logo = [[
      ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
      ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
      ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
      ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
      ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

      logo = string.rep('\n', 8) .. logo .. '\n\n'
      dashboard.section.header.val = vim.split(logo, '\n')
    --stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files<cr>'), -- 
      dashboard.button('n', '󱇧 ' .. ' New file', ':ene <BAR> startinsert<cr>'),
      dashboard.button('r', '󰈙 ' .. ' Recent files', ':Telescope oldfiles<cr>'),
      dashboard.button('w', '󰈭 ' .. ' Find word', ':Telescope live_grep<cr>'),
      dashboard.button('s', '󰦛 ' .. ' Restore Session', [[:lua require("persistence").load()<cr>]]),
      dashboard.button('c', ' ' .. ' Config', ':e $MYVIMRC<cr>'),
      dashboard.button('l', '󰒲 ' .. ' Lazy', ':Lazy<cr>'),
      dashboard.button('q', ' ' .. ' Quit', ':qa<cr>'),
    }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = 'AlphaButtons'
        button.opts.hl_shortcut = 'AlphaShortcut'
      end
      dashboard.section.footer.opts.hl = 'Type'
      dashboard.section.header.opts.hl = 'AlphaHeader'
      dashboard.section.buttons.opts.hl = 'AlphaButtons'
      dashboard.opts.layout[1].val = 8

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'AlphaReady',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      require('alpha').setup(dashboard.opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = string.format(
            '⚡ Neovim loaded %d/%d plugins in %.2fms',
            stats.loaded,
            stats.count,
            ms
          )
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  {
    'nvimdev/dashboard-nvim',
    enabled = false,
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    opts = function()
      local logo = [[
     ██╗██╗   ██╗██╗███╗   ███╗          Z
     ██║██║   ██║██║████╗ ████║      Z    
     ██║██║   ██║██║██╔████╔██║   z       
██   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ z         
╚█████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
      logo = string.rep('\n', 8) .. logo .. '\n\n'
      local opts = {
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, '\n'),
          --stylua: ignore
          center = {
            { key = 'f', icon = ' ', desc = ' Find file', action = ':Telescope find_files<cr>', },
            { key = 'n', icon = '󱇧 ', desc = ' New file', action = ':ene <BAR> startinsert<cr>', },
            { key = 'r', icon = '󰈙 ', desc = ' Recent files', action = ':Telescope oldfiles<cr>', },
            { key = 'w', icon = '󰈭 ', desc = ' Find word', action = ':Telescope live_grep<cr>', },
            { key = 's', icon = '󰦛 ', desc = ' Restore Session', action = ':lua require("persistence").load()<cr>', },
            { key = 'c', icon = ' ', desc = ' Config', action = ':e $MYVIMRC<cr>', },
            { key = 'l', icon = '󰒲 ', desc = ' Lazy', action = ':Lazy<cr>', },
            { key = 'h', icon = '? ', desc = ' Find help', action = ':Telescope help_tags<cr>', },
            { key = 'q', icon = ' ', desc = ' Quit', action = ':qa<cr>', },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              '⚡ Neovim loaded '
                .. stats.loaded
                .. '/'
                .. stats.count
                .. ' plugins in '
                .. ms
                .. 'ms',
            }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
        button.key_format = '  %s'
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == 'lazy' then
        vim.api.nvim_create_autocmd('WinClosed', {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds('UIEnter', { group = 'dashboard' })
            end)
          end,
        })
      end

      return opts
    end,
  },
}
