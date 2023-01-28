local cmd = vim.cmd

local M = {}

M.map = function(mode, keys, exec, opts)
  local common = { silent = true, noremap = true }

  if not opts then
    opts = common
  else
    vim.tbl_extend('force', opts, common)
  end

  vim.keymap.set(mode, keys, exec, opts)
end

M.handle_new_buf = function(opts)
  local name = vim.fn.input 'Enter file name: '

  if name == '' then
    return
  end

  local path = ' %:h/' .. name

  if not opts then
    cmd('e' .. path)
    return
  end

  if opts.type == 'v' then
    cmd('vsplit' .. path)
  else
    cmd('split' .. path)
  end
end

return M
