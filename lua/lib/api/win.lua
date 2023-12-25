local api = vim.api

local buf, win

local function open_window()
  buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- get dimensions
  local width = api.nvim_get_option('columns')
  local height = api.nvim_get_option('lines')

  -- calculate floating window size
  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)

  -- calculate starting position
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  -- create the window attached to the buffer
  win = api.nvim_open_win(buf, true, {
    style = 'minimal',
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = 'rounded',
  })
end

open_window()

--- open new buffer as horizontal split
local function open_split()
  api.nvim_command('split new')
  api.nvim_command('enew')
  buf = api.nvim_get_current_buf()
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'buftype', 'nofile')

  -- set the heigh to 20% of the screen
  local height = math.ceil(api.nvim_get_option('lines') * 0.2)
  api.nvim_win_set_height(0, height)
end

-- open_split()
