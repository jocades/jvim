local api = vim.api
local win, buf

api.nvim_create_autocmd({ 'BufEnter, BufWinEnter' }, {
  once = true,
  pattern = '*',
  callback = function() P { type = 'bufenter / winenter' } end,
})

local new_scratch_buf = function()
  -- create new buffer, display it in a new vwindow and name it to scratch
  buf = api.nvim_create_buf(false, true)
  --vim.api.nvim_buf_set_name(buf, 'scratch')
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- get dimensions
  local width = api.nvim_get_option 'columns'
  local height = api.nvim_get_option 'lines'

  -- calculate our floating window size
  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)

  -- and its starting position
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  -- set some options
  local opts = {
    style = 'minimal',
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
  }

  -- and finally create it with buffer attached
  win = api.nvim_open_win(buf, true, opts)
end

local add_link = function()
  api.nvim_buf_set_lines(buf, 0, -1, false, { '*hello world' })

  -- how can i add a link to a line in my project?
  api.nvim_buf_add_highlight(buf, -1, 'Todo', 0, 0, -1)

  -- how can i add a link to a line in another file in my project?
end

vim.keymap.set('n', '<leader>td', function() new_scratch_buf() end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>tl', function() add_link() end, { noremap = true, silent = true })
