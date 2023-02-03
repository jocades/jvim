return {
  'goolord/alpha-nvim',
  enabled = true,
  event = 'VimEnter',
  config = function()
    local dashboard = require 'alpha.themes.dashboard'
    -- dynamic header padding
    --[[ local fn = vim.fn
    local marginTopPercent = 0.3 ]]
    -- local headerPadding = fn.max { 2, fn.floor(fn.winheight(0) * marginTopPercent) }
    local logo = [[
      "The computing scientist's main challenge is not to get confused
                by the complexities of his own making."
      
                          - Edsger W. Dijkstra
      
                     ⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⣀⣤⣶⣾⣿⣿⣷⣶⣤⣀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀
                     ⠀⠀⠀⠀⠀⠀⠜⠉⣿⡆⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢰⣿⠉⠃⠀⠀⠀⠀⠀
                     ⠀⠀⢀⣤⣴⣦⣄⣴⠟⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡎⢻⣦⣠⣴⣦⣄⠀⠀
                     ⠀⠀⡞⠁⣠⣾⢿⣧⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣽⡿⣷⣄⠈⢷⠀
                     ⠀⠀⣠⣾⠟⠁⢸⣿⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⣿⡇⠈⠻⣷⣄⠀
                     ⠀⣰⡿⠁⠀⢀⣾⣏⣾⣄⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣰⣷⣹⣷⠀⠀⠈⢿⣆
                     ⠀⣿⡇⠀⢠⣾⠏⢸⣿⣿⣿⣿⠋⢻⣿⣿⣿⣿⡟⠙⣿⣿⣿⣿⡇⠹⣷⡀⠀⢸⣿
                     ⠀⠹⣿⣴⡿⠋⠀⠈⠛⠉⣹⣿⣦⣄⡹⣿⣿⣋⣠⣶⣿⣏⠉⠛⠁⠀⠙⢿⣦⣿⠏
                     ⠀⠀⣸⣿⠿⠿⣿⣾⣿⡿⠿⣿⣿⣿⣿⡆⢰⣿⣿⣿⣿⠿⢿⣿⣶⣿⠿⠿⣻⣇⠀
                     ⠀⠀⣿⡇⢀⣴⣶⣤⣀⣴⣿⠿⣻⡿⣿⣧⣾⣿⢿⣟⠿⣿⣦⣀⣤⣶⣦⠀⢸⣿⠀
                     ⠀⠀⢿⣧⠈⠃⢀⣵⣿⡋⠁⢀⣿⡷⣿⡇⢻⣿⣿⣿⡀⠈⢛⣿⣮⡀⠘⠀⣼⡟⠀
                     ⠀⠀⠈⠻⣷⣤⣟⣋⣿⣧⣴⡿⠋⠀⣿⡇⢸⣿⠀⠙⢿⣦⣼⣿⣙⣻⣤⣾⠟⠁⠀
                     ⠀⠀⠀⠀⠈⢽⣿⠛⢻⣏⢉⣤⣶⣶⣿⠁⠈⣿⣶⣶⣤⡉⣽⡟⠛⣿⡏⠁⠀⠀⠀
                     ⠀⠀⠀⠀⠀⠈⠿⣷⣾⣾⣟⣉⣠⣿⢿⡇⢸⠿⣿⣄⣙⣻⣷⣷⣾⠿⠁⠀⠀⠀⠀
                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠛⢁⡼⠃⠘⢦⡈⠛⠿⠟⠃⠀⠀⠀⠀⠀⠀⠀⠀
]]
    dashboard.section.header.val = vim.split(logo, '\n')
    dashboard.section.buttons.val = {
      dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files <CR>'), -- 
      dashboard.button('e', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles <CR>'),
      dashboard.button('w', ' ' .. ' Find word', ':Telescope live_grep <CR>'),
      dashboard.button('p', ' ' .. ' Find project', ":lua require('telescope').extensions.projects.projects()<CR>"),
      dashboard.button('c', ' ' .. ' Config', ':e $MYVIMRC <CR>'),
      dashboard.button('l', '鈴' .. ' Lazy', ':Lazy<CR>'),
      --dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
      dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = 'AlphaButtons'
      button.opts.hl_shortcut = 'AlphaShortcut'
    end
    dashboard.section.footer.opts.hl = 'Type'
    dashboard.section.header.opts.hl = 'AlphaHeader'
    dashboard.section.buttons.opts.hl = 'AlphaButtons'
    --dashboard.opts.opts.noautocmd = true

    require('alpha').setup(dashboard.opts)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
