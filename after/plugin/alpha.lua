local present, alpha = pcall(require, 'alpha')
if not present then
  return
end

local dashboard = require 'alpha.themes.dashboard'
-- dynamic header padding
local fn = vim.fn
local marginTopPercent = 0.3
local headerPadding = fn.max { 2, fn.floor(fn.winheight(0) * marginTopPercent) }

dashboard.section.header.val = {
  [[                               __                ]],
  [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

-- draw me a bomb please

dashboard.section.buttons.val = {
  dashboard.button('f', ' ' .. ' Find files', ':Telescope find_files <CR>'),
  dashboard.button('e', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('p', ' ' .. ' Find project', ":lua require('telescope').extensions.projects.projects()<CR>"),
  dashboard.button('r', '' .. ' Recent files', ':Telescope oldfiles <CR>'),
  dashboard.button('t', '' .. ' Find word', ':Telescope live_grep <CR>'),
  dashboard.button('c', ' ' .. ' Config', ':e $MYVIMRC <CR>'),
  dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
}

local function footer()
  -- local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':t') -- get current dir name
  local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':~:.') -- get current dir name from $HOME
  local branch = vim.fn.system 'git rev-parse --abbrev-ref HEAD'
  local icon = ''
  if branch == '' then
    branch = 'no branch'
    icon = ''
  end

  return string.format('%s %s %s', '       Hello j0rdi!' .. '\n' .. icon, dir, ' ' .. branch)
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = 'Type'
dashboard.section.header.opts.hl = 'Include'
dashboard.section.buttons.opts.hl = 'Keyword'
dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
