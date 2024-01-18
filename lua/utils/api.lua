local api = vim.api
local str = require('utils.str')

local M = {}

---@alias File { path: string, dir: string,  name: string, stem: string, ext: string, type: string, split: fun(): string[] }

function M.get_curr_buf() return api.nvim_get_current_buf() end

---@param path? string
---@return File
function M.File(path)
  if path == nil then
    path = vim.api.nvim_buf_get_name(0)
  end

  return {
    path = path,
    dir = vim.fn.fnamemodify(path, ':h'),
    name = vim.fn.fnamemodify(path, ':t'),
    stem = vim.fn.fnamemodify(path, ':t:r'),
    ext = vim.fn.fnamemodify(path, ':e'),
    type = vim.api.nvim_buf_get_option(0, 'filetype'),
    split = function() return str.split(path, '/') end,
  }
end

---@return File
function M.get_curr_file()
  local path = vim.api.nvim_buf_get_name(0)
  return {
    path = path,
    dir = vim.fn.fnamemodify(path, ':h'),
    name = vim.fn.fnamemodify(path, ':t'),
    stem = vim.fn.fnamemodify(path, ':t:r'),
    ext = vim.fn.fnamemodify(path, ':e'),
    type = vim.api.nvim_buf_get_option(0, 'filetype'),
    split = function() return str.split(path, '/') end,
  }
end

---@param buf number
---@param data string[]
---@param opts? { append: boolean }
function M.write_to_buf(buf, data, opts)
  if opts ~= nil and opts.append then
    api.nvim_buf_set_lines(buf, -1, -1, true, data)
  else
    api.nvim_buf_set_lines(buf, 0, -1, false, data)
  end
end

---@param opts { name: string, direction?: 'horizontal' | 'vertical', size?: number }
function M.new_scratch_buf(opts)
  if opts.direction == 'horizontal' then
    vim.cmd.new()
  else
    vim.cmd.vnew()
  end

  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_name(buf, opts.name)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  if opts.size and opts.direction == 'horizontal' then
    local height = math.ceil(vim.api.nvim_get_option('lines') * opts.size)
    vim.api.nvim_win_set_height(0, height)
  else
    if opts.size and opts.direction == 'vertical' then
      local width = math.ceil(vim.api.nvim_get_option('columns') * opts.size)
      vim.api.nvim_win_set_width(0, width)
    end
  end

  vim.cmd.wincmd('p')

  return buf
end

function M.new_floating_win()
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  local width = api.nvim_get_option('columns')
  local height = api.nvim_get_option('lines')
  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local win = api.nvim_open_win(buf, true, {
    style = 'minimal',
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = 'rounded',
  })

  return buf, win
end

function M.get_buf_names()
  local bufs = api.nvim_list_bufs()
  local names = {}
  for _, buf in ipairs(bufs) do
    table.insert(names, api.nvim_buf_get_name(buf))
  end

  return names
end

function M.get_buf_by_name(name)
  local bufs = api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if api.nvim_buf_get_name(buf) == name then
      return buf
    end
  end
end

return M
