local M = {}

M.get_curr_buf = function(_) return vim.api.nvim_get_current_buf() end

M.write_to_buf = function(_, buf, start, finish, clear, data)
  if clear then
    vim.api.nvim_buf_set_lines(buf, start, finish, false, {})
  end

  vim.api.nvim_buf_set_lines(buf, start, finish, false, data)
end

M.new_buf = function(self)
  vim.cmd.new()
  return self.get_curr_buf()
end

M.new_nofile_buf = function(_, name)
  vim.cmd.new()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(buf, name)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  return buf
end

M.get_file_path = function(_, bufnr)
  if not bufnr then
    return vim.api.nvim_buf_get_name(0)
  end
  return vim.api.nvim_buf_get_name(bufnr)
end

M.get_file_name = function(self, path)
  local regex = '([^/]+)$'
  if not path then
    return self.get_file_path():match(regex)
  end
  return path:match(regex)
end

M.get_file_ext = function(self, path)
  local regex = '%.([^.]+)$'
  if not path then
    return self.get_file_path():match(regex)
  end
  return path:match(regex)
end

M.print_err = function(_, msg) vim.notify(msg, vim.log.levels.ERROR) end

M.get_command = function(_, ext)
  local commands = {
    py = 'python',
    lua = 'lua',
    js = 'node',
    ts = 'ts-node',
    sh = 'bash',
  }

  return commands[ext]
end

M.get_buf_names = function(_)
  local bufs = vim.api.nvim_list_bufs()
  local names = {}
  for _, buf in ipairs(bufs) do
    table.insert(names, vim.api.nvim_buf_get_name(buf))
  end

  return names
end

M.get_buf_by_name = function(_, name)
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_get_name(buf) == name then
      return buf
    end
  end
end

M.test_module_relaod = function() return 5 end

return M
