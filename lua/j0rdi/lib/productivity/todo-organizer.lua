local api = vim.api

local function print_err(msg) vim.notify(msg, vim.log.levels.ERROR) end
-- TODO: testing

local function get_cursor()
  local cursor = api.nvim_win_get_cursor(0)
  return {
    y = cursor[1],
    x = cursor[2],
  }
end

local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
local data_dir = git_root .. '/_data-todos/'

local function set_todo()
  local line = api.nvim_get_current_line()
  local cursor = get_cursor()
  local new_line = string.format('%s-- TODO: %s', line:sub(1, cursor.x), line:sub(cursor.x + 1))
  api.nvim_set_current_line(new_line)
  api.nvim_feedkeys('A', 'n', true)
end

vim.keymap.set('n', '<leader>td', set_todo, { noremap = true })

local function on_save()
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  local file_info = {}
  local todos = {}

  for i, line in ipairs(lines) do
    local todo = line:match '(.+)TODO:(.+)'
    if todo then
      table.insert(todos, {
        text = line:sub(todo:len() + 1),
        mark = {
          y = i,
          x = #todo,
        },
      })
    end
  end

  if vim.tbl_isempty(todos) then
    return
  end

  file_info[api.nvim_buf_get_name(0)] = { todos = todos }
  --P(file_info)

  local data_path = string.format('%s%s.txt', data_dir, vim.fn.expand '%:t:r')
  local file = io.open(data_path, 'w')

  if not file then
    print_err('Could not open todos file: ' .. data_path)
    return
  end

  for file_path, data in pairs(file_info) do
    file:write(string.format('PATH: %s\n', file_path))
    for i, todo in ipairs(data.todos) do
      file:write(string.format('  %d**%d:%d** %s\n', i, todo.mark.y, todo.mark.x, todo.text))
    end
  end

  file:close()
end

local group = api.nvim_create_augroup('j0rdi-todos', { clear = true })
api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = git_root .. '/**/*',
  callback = function() print 'saved' end,
})

-- DISPLAY --
local function scan_todos_data()
  local files = vim.fn.globpath(data_dir, '*.txt', true, true)
  local todos = {}

  for _, f in ipairs(files) do
    local file = io.open(f, 'r')
    if not file then
      vim.notify('Could not open todos file: ' .. f, vim.log.levels.ERROR)
      return
    end

    local file_path = nil
    local file_todos = {}

    for line in file:lines() do
      local path = line:match 'PATH: (.+)'
      if path then
        file_path = path
      else
        local y, x = line:match '%*%*(%d+):(%d+)%*%*'
        local text = line:match 'TODO: (.+)'

        if y and x and text then
          table.insert(file_todos, {
            text = text,
            mark = {
              y = tonumber(y),
              x = tonumber(x),
            },
          })
        end
      end
    end

    if file_path then
      todos[file_path] = file_todos
    end

    file:close() -- Note that files are automatically closed when their handles are garbage collected, but that takes an unpredictable amount of time to happen.
  end

  return todos
end

-- TODO: maybe use telescope for this? How would i display the file in the preview?
local function display_todos(win)
  local todos_data = scan_todos_data()
  P(todos_data)
  if not todos_data then
    return
  end

  local lines = {}

  for file_path, data in pairs(todos_data) do
    table.insert(lines, string.format('- File: %s', file_path))
    for i, todo in ipairs(data) do
      table.insert(lines, string.format('  %d- %s', i, todo.text))
    end
    table.insert(lines, '--------------------')
  end

  -- open new buffer on the bottom with 30% of the height
  vim.cmd.new()
  vim.cmd.resize(20)
  api.nvim_buf_set_lines(0, 0, -1, false, lines)
  api.nvim_buf_set_option(0, 'buftype', 'nofile')
  api.nvim_buf_set_option(0, 'bufhidden', 'wipe')
  api.nvim_win_set_cursor(0, { 2, 0 })

  local function on_enter()
    local cursor = get_cursor()
    local line = lines[cursor.y]
    local index = line:match '%d+'

    local file_path = nil
    for i = cursor.y, 1, -1 do
      local path = lines[i]:match 'File: (.+)'
      if path then
        file_path = path
        break
      end
    end

    if not file_path or not index then
      print 'Error while parsing todo'
      return
    end

    local todo = todos_data[file_path][tonumber(index)]
    if not todo then
      print_err 'Could not find todo'
      return
    end

    print('todo', todo.text)
    P(todo)

    vim.cmd.wincmd 'p'
    vim.cmd.edit(file_path)
    api.nvim_win_set_cursor(0, { todo.mark.y, todo.mark.x })
    api.nvim_feedkeys('zz', 'n', true)
  end

  -- remap enter to a custom action only in this buffer
  vim.keymap.set('n', '<cr>', on_enter, { buffer = 0 })
end

api.nvim_create_user_command('Todos', function() display_todos(api.nvim_get_current_win()) end, {})
