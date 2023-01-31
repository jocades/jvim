local t = {}

for i = 1, 10 do
  table.insert(t, {
    x = i,
    y = i,
    text = i .. 'some text',
  })
end

print(t[6].x)

local todos = {
  ['/path/to/file'] = t,
  ['/path/to/file1'] = t,
}

local function get_todos_file()
  local todos_file = vim.fn.stdpath 'data' .. '/todos.txt'
  return todos_file
end

local function scan_todos_file()
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
