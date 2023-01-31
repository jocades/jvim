--vim.cmd [[colorscheme onedark]]

local colorscheme = 'tokyonight-night'

local present, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)

if not present then
  return vim.notify('colorscheme ' .. colorscheme .. ' not found!', 3)
end

-- Vim Log Levels
-- 0 = trace
-- 1 = debug
-- 2 = info
-- 3 = warn
-- 4 = error
-- 5 = off
