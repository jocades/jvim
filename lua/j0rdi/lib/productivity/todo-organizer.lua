local api = vim.api
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

local function scan_file(file_path)
  if vim.fn.isdirectory(file_path) == 1 then
    return
  end

  if vim.fn.filereadable(file_path) == 0 then
    return
  end

  local file = io.open(file_path, 'r')
  if not file then
    vim.notify('Could not open file: ' .. file_path, vim.log.levels.ERROR)
    return
  end

  local todos = {}
  local line_nr = 0

  for line in file:lines() do
    line_nr = line_nr + 1
    local todo = line:match '(.+)TODO:(.+)'
    if todo then
      table.insert(todos, {
        text = line:sub(todo:len() + 1),
        mark = {
          y = line_nr,
          x = #todo,
        },
      })
    end
  end
  file:close()
  --P(todos)

  return todos
end

--scan_file(vim.fn.expand '%:p')

local function scan_todos()
  local todos = {}
  local files = vim.fn.systemlist 'git ls-files | grep .lua$'
  for i, f in ipairs(files) do
    files[i] = string.format('%s/%s', git_root, f)
  end

  --print(vim.inspect(files))

  for _, f in ipairs(files) do
    local file_todos = scan_file(f)
    if not file_todos or vim.tbl_isempty(file_todos) then
      todos[f] = nil
    else
      todos[f] = file_todos
    end
  end

  return todos
end

--P(scan_todos())

local function save_todos_data(todos)
  for file_path, data in pairs(todos) do
    if not data then
      goto continue
    end

    -- extract the file name without the extension from the file path
    local file_name = file_path:match '^.+/(.+)$'
    local data_path = string.format('%s%s.txt', data_dir, file_name)

    print(data_path)
    local file = io.open(data_path, 'w')
    if not file then
      return
    end

    file:write(string.format('PATH: %s\n', file_path))

    for i, todo in ipairs(data) do
      file:write(string.format('  %d**%d:%d** %s\n', i, todo.mark.y, todo.mark.x, todo.text))
    end

    file:close()
    ::continue::
  end
end

--save_todos_data(scan_todos())

local global_todos = scan_todos()
save_todos_data(global_todos)

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
    vim.notify('Could not open todos file', vim.log.levels.ERROR)
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

-- IDEA: use a buffer as db to store the todos and load them on startup
-- use the db to display the todos in a floating window with a nice structure
-- the todos will no be display the x and y position of the todo in the file
-- so i will need to map the todo of the display with the todo in the file and retrieve the x and y position of the todo in that file(key)
--
-- the db will be a table like so:
-- {
-- '/path/to/file': {
-- todos: {
-- 1: {
-- text: 'some text',
-- mark: {x = 1, y = 1},
-- },
-- 2: {
-- text: 'some text',
-- mark: {x = 1, y = 1},
-- },
-- },
-- },
-- '/path/to/file': {
-- ...
-- },
--
-- when the user press enter on a todo in the floating window, the plugin will jump to the todo in the file and set the cursor at the right position
-- it will be displayed like so:
-- - '/path/to/file' (from git root)
-- 1- some text
-- 2- some text
-- --------------------
--
-- - '/path/to/file' (from git root)
-- 1- some text
-- etc...

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

local function display_todos()
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
    local curr_line = lines[cursor.y]
    local index = curr_line:match '%d+'

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
      vim.notify('Could not find todo', vim.log.levels.ERROR)
      return
    end

    print('todo', todo.text)
    P(todo)

    vim.cmd.e(file_path)
    api.nvim_win_set_cursor(0, { todo.mark.y, todo.mark.x })
    api.nvim_feedkeys('zz', 'n', true)
  end

  -- remap enter to a custom action only in this buffer
  vim.keymap.set('n', '<cr>', on_enter, { buffer = 0 })
  --
  -- -- set the keymap
  -- vim.keymap.set('n', '<leader>tk', jump_to_todo, { buffer = buf })
end

api.nvim_create_user_command('Todos', function() display_todos() end, {})
