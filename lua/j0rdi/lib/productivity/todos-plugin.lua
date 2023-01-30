local api = vim.api

local function get_cursor()
  local cursor = api.nvim_win_get_cursor(0)
  return {
    x = cursor[1],
    y = cursor[2],
  }
end

local function get_todos_file()
  return string.format('%s/todos', vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', ''))
end

local function set_todo()
  local line = api.nvim_get_current_line()
  local cursor = get_cursor()
  local new_line = line:sub(1, cursor.y) .. '-- TODO: ' .. line:sub(cursor.y + 1)
  api.nvim_set_current_line(new_line)
  api.nvim_feedkeys('A', 'n', true)

  -- local todo = {
  --   file_path = api.nvim_buf_get_name(0),
  --   mark = cursor,
  -- }

  -- -- 3. append the info of the todo to a file in the git root called 'todos'
  -- local todos_file = string.format('%s/todos', vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', ''))
  -- --  local todo_line = todo.file_path .. ':' .. todo.mark.x .. ':' .. todo.mark.y
  -- print(todos_file)
  --
  -- -- 4. write the todo to the file
  -- local file = io.open(todos_file, 'a')
  -- file:write(todo.file_path .. ':' .. todo.mark.x .. ':' .. todo.mark.y .. '\n')
  -- file:close()
end

vim.keymap.set('n', '<leader>td', set_todo, { noremap = true })

-- To improve:
-- ISSUE: when saving the file it gets formated and the todo positon changes
-- SOLUTION: whne set_todo is called we know this is a file we have to keep track of,
-- keep track of all the

-- Read the lines from a buffer on save and scan for the `-- TODO:` pattern
-- If found, add it to the todos file
-- If not found, remove it from the todos file

-- keep track of the todos in the current file if there are any append the file_name and number of todos to the todo_files table
local function on_save()
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  local todos = {}
  for i, line in ipairs(lines) do
    local todo = line:match '(.+)-- TODO:(.+)'
    if todo then
      table.insert(todos, {
        text = todo,
        mark = {
          x = i,
          y = #todo,
        },
      })
    end
  end

  -- Keep track of marked files
  local todo_files = {}

  if not vim.tbl_isempty(todos) then
    todo_files[api.nvim_buf_get_name(0)] = { count = vim.tbl_count(todos), todos = todos }
    P(todo_files)
  end

  local todos_file = get_todos_file()
  local file = io.open(todos_file, 'w')

  for file_path, data in pairs(todo_files) do
    for _, todo in ipairs(data.todos) do
      file:write(file_path .. ':' .. todo.mark.x .. ':' .. todo.mark.y .. '\n')
    end
  end

  file:close()
end

local group = api.nvim_create_augroup('j0rdi-todos', { clear = true })

api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = '*.lua',
  callback = on_save,
})
-- TODOS NAVIGATION
local function jump_to_todo()
  -- 1. get the file path and line number from the todos file
  local line = api.nvim_get_current_line()
  local file_path, x, y = line:match '(.+):(%d+):(%d+)'
  -- 2. open the file and jump to the line
  vim.cmd(string.format('e %s', file_path))
  api.nvim_win_set_cursor(0, { tonumber(x), tonumber(y) })
  vim.cmd 'normal! zz'
end

api.nvim_create_autocmd('BufEnter', {
  group = group,
  pattern = get_todos_file(),
  callback = function() vim.keymap.set('n', '<leader>tk', jump_to_todo, { buffer = 0 }) end,
})
