local function test()
  require('neo-tree.command').execute({
    position = 'current',
    toggle = true,
    reveal = true,
  })

  -- vim.print(vim.api.nvim_get_current_buf())
  print(vim.bo.filetype, vim.bo.buflisted)
  vim.bo.bufhidden = 'wipe'
  -- vim.bo.buflisted = false
end

-- test()

local path = vim.api.nvim_buf_get_name(0)
local cmd = ('git show HEAD~1:%s'):format(path)
print(cmd)
local out = JVim.exe(cmd)
vim.print(out)

-- local buf = vim.api.nvim_create_buf(true, false)
-- print(buf)
-- vim.api.nvim_set_current_buf(buf)
-- vim.api.nvim_buf_set_name(buf, 'diffit')
