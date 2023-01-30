local api = vim.api
-- TODO: testing

local function get_cursor()
  local cursor = api.nvim_win_get_cursor(0)
  return {
    x = cursor[1],
    y = cursor[2],
  }
end

local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')

local function get_todos_file() return string.format('%s/todos', git_root) end

local function set_todo()
  local line = api.nvim_get_current_line()
  local cursor = get_cursor()
  local new_line = line:sub(1, cursor.y) .. '-- TODO: ' .. line:sub(cursor.y + 1)
  api.nvim_set_current_line(new_line)
  api.nvim_feedkeys('A', 'n', true)
end

vim.keymap.set('n', '<leader>td', set_todo, { noremap = true })

local todo_files = {}

local function on_save()
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  local todos = {}
  for i, line in ipairs(lines) do
    local todo = line:match '(.+)-- TODO:(.+)'
    if todo then
      print(todo)
      table.insert(todos, {
        text = line:sub(todo:len() + 1),
        mark = {
          x = i,
          y = #todo,
        },
      })
    end
  end

  if not vim.tbl_isempty(todos) then
    todo_files[api.nvim_buf_get_name(0)] = { count = vim.tbl_count(todos), todos = todos }
    P(todo_files)
  end

  local todos_file = get_todos_file()
  local file = io.open(todos_file, 'w')
  if not file then
    vim.notify('Could not open todos file', vim.log.levels.ERROR)
    return
  end

  for file_path, data in pairs(todo_files) do
    file:write(string.format('\nPATH: %s\n', file_path))
    file:write(string.rep('-', 20) .. '\n')

    for i, todo in ipairs(data.todos) do
      file:write(string.format('  %d**%d:%d** %s\n', i, todo.mark.x, todo.mark.y, todo.text))
    end
  end

  file:close()
end

local jump_to_todo = function()
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)

  local file_path = nil
  local cursor = get_cursor()
  for i = cursor.x, 1, -1 do
    local path = lines[i]:match 'PATH: (.+)'
    if path then
      file_path = path
      break
    end
  end

  local curr_line = lines[cursor.x]
  local x, y = curr_line:match '%*%*(%d+):(%d+)%*%*'

  if not file_path or not x or not y then
    vim.notify('Could not find todo', vim.log.levels.ERROR)
    return
  end

  vim.cmd('e ' .. file_path)
  api.nvim_win_set_cursor(0, { tonumber(x), tonumber(y) })
  api.nvim_feedkeys('zz', 'n', true)
end

local group = api.nvim_create_augroup('j0rdi-todos', { clear = true })

api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = git_root .. '/*',
  callback = on_save,
})

api.nvim_create_autocmd('BufEnter', {
  group = group,
  pattern = get_todos_file(),
  callback = function()
    print 'onBufEnter'
    vim.keymap.set('n', '<leader>tk', jump_to_todo, { buffer = 0 })
  end,
  once = true,
})

-- TODOS NAVIGATION
local function scan_todos_file()
  -- the file will have the following format
  -- PATH: /path/to/file
  -- --------------------
  -- 1**1:1** TODO: some text
  -- 2**1:1** TODO: some text
  -- PATH: /path/to/file
  -- --------------------
  -- 1**1:1** TODO: some text

  -- retrieve a table like so: {
  --  '/path/to/file': {
  --  todos: {{x = 1, y =1}, {x = 1, y = 1}}
  -- },
  -- '/path/to/file': {
  -- ...
  -- }

  local todos_file = get_todos_file()
  local file = io.open(todos_file, 'r')
  if not file then
    vim.notify('Could not open todos file', vim.log.levels.ERROR)
    return
  end

  local todos = {}
  local file_path = nil

  for line in file:lines() do
    local path = line:match 'PATH: (.+)'
    if path then
      file_path = path
      todos[file_path] = {}
    else
      local todo = line:match '(%d+)%*%*(%d+):(%d+)%*%* TODO:(.+)'
      if todo then
        table.insert(todos[file_path], {
          x = tonumber(todo[2]),
          y = tonumber(todo[3]),
          text = todo[4],
        })
      end
    end
  end

  file:close()

  return todos
end

-- api.nvim_create_user_command('Todos', function() display_todos() end, {})
--
-- local display_todos = function()
--   local todos = scan_todos_file()
--   if not todos then
--     print 'No todos found'
--     return
--   end
--
--   -- create a buffer to the right of the current one
--   -- add the todos with the following format
--   -- PATH: /path/to/file
--   -- --------------------
--   -- 1** TODO: some text
--
--   local h = require 'j0rdi.lib.helpers'
--   local buf = h:new_buf()
--
--   local lines = {}
--   for file_path, data in pairs(todos) do
--     table.insert(lines, string.format('PATH: %s', file_path))
--     table.insert(lines, string.rep('-', 20))
--     for i, todo in ipairs(data) do
--       table.insert(lines, string.format('  %d** %s', i, todo.text))
--     end
--   end
--
--   api.nvim_buf_set_lines(buf, 0, -1, false, lines)
--
--   --
-- end
