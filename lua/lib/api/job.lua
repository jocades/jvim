local dir = '/Users/j0rdi/.config/nvim/lua/lib/plugins/autorun/test'
local file = 'exec.c'
local output = dir .. '/exec.out'

local buf = 35

vim.fn.jobstart({ 'gcc', dir .. '/' .. file, '-o', output }, {
  stdout_buffered = true,
  on_stdout = function(_, data, event) vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(data, '\n')) end,
})
