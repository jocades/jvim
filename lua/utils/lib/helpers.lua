local api = vim.api

local M = {}

function M.get_curr_buf(_) return api.nvim_get_current_buf() end

function M.write_to_buf(_, buf, start, finish, clear, data)
  if clear then
    api.nvim_buf_set_lines(buf, start, finish, false, {})
  end

  api.nvim_buf_set_lines(buf, start, finish, false, data)
end

function M.new_buf(self)
  vim.cmd.new()
  return self.get_curr_buf()
end

function M.new_nofile_buf(_, name)
  vim.cmd.new()
  local buf = api.nvim_get_current_buf()
  api.nvim_buf_set_name(buf, name)
  api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  return buf
end

function M.get_file_path(_, bufnr)
  if not bufnr then
    return api.nvim_buf_get_name(0)
  end
  return api.nvim_buf_get_name(bufnr)
end

function M.get_file_name(self, path)
  local regex = '([^/]+)$'
  if not path then
    return self.get_file_path():match(regex)
  end
  return path:match(regex)
end

function M.get_file_ext(self, path)
  local regex = '%.([^.]+)$'
  if not path then
    return self.get_file_path():match(regex)
  end
  return path:match(regex)
end

function M.print_err(_, msg) vim.notify(msg, vim.log.levels.ERROR) end

function M.get_command(_, ext)
  local commands = {
    py = 'python',
    lua = 'lua',
    js = 'node',
    ts = 'ts-node',
    sh = 'bash',
  }

  return commands[ext]
end

function M.get_buf_names(_)
  local bufs = api.nvim_list_bufs()
  local names = {}
  for _, buf in ipairs(bufs) do
    table.insert(names, api.nvim_buf_get_name(buf))
  end

  return names
end

function M.get_buf_by_name(_, name)
  local bufs = api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if api.nvim_buf_get_name(buf) == name then
      return buf
    end
  end
end

function M.test_module_relaod() return 5 end

return M
