local api = vim.api

local M = {}

---@param msg string
function M.print_err(msg) vim.notify(msg, vim.log.levels.ERROR) end

function M.get_curr_buf() return api.nvim_get_current_buf() end

---@return { path: string, name: string, ext: string, type: string }
function M.get_curr_file()
  local path = vim.api.nvim_buf_get_name(0)
  return {
    path = path,
    name = vim.fn.fnamemodify(path, ':t'),
    ext = vim.fn.fnamemodify(path, ':e'),
    type = vim.api.nvim_buf_get_option(0, 'filetype'),
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

function M.new_scratch_buf(horizontal)
  if not horizontal then
    vim.cmd('vnew')
  else
    vim.cmd('new')
  end

  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_name(buf, 'autorun')
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  return buf
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
