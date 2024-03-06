local env = require('config.env')
local log = require('utils.log')
local shell = require('utils').shell

local M = {}

local function get_selected_text()
  local a_orig = vim.fn.getreg('a')
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' then vim.cmd([[normal! gv]]) end
  vim.cmd([[silent! normal! "aygv]])
  local text = vim.fn.getreg('a')
  vim.fn.setreg('a', a_orig)
  return text
end

local function set_selected_text(text)
  local a_orig = vim.fn.getreg('a')
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' then vim.cmd([[normal! gv]]) end
  vim.cmd([[silent! normal! "aygv]])
  vim.fn.setreg('a', text)
  vim.cmd([[silent! normal! "ap]])
  vim.fn.setreg('a', a_orig)
end

--
-- Megustan las manzanas
-- y las peras

local py = string.format(
  'OPENAI_API_KEY=%s python ~/dev/ai/aicli/aicli/cmd.py',
  env.OPENAI_API_KEY
)

function M.fix_typo()
  local selected_text = get_selected_text()
  local command = string.format('%s "%s"', py, selected_text)

  -- print('Selected text:', selected_text)
  -- print('Command:', command)

  local out = shell(command)
  if not out then
    log.warn('Failed to get response from AI')
    return
  end

  set_selected_text(out)
end

---@param opts? { trigger: string }
function M.setup(opts)
  opts = opts or {}

  if opts.trigger == nil then opts.trigger = '<leader>f' end

  vim.keymap.set(
    'v',
    opts.trigger,
    function() M.fix_typo() end,
    { silent = true, noremap = true }
  )
end

return M
