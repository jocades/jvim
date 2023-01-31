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
