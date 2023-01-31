local t = {}

for i = 1, 10 do
  table.insert(t, {
    x = i,
    y = i,
    text = i .. 'some text',
  })
end

--print(t[6].x)

-- for i, v in ipairs(t) do
--   if i == 6 then
--     return
--   end
--   print(i)
-- end

-- how to make the above but continue if i == 6? and just ignore it?
for i, v in ipairs(t) do
  if i == 6 then
    goto continue
  end
  print(i)
  ::continue::
end

local todos = {
  ['/path/to/file'] = t,
  ['/path/to/file1'] = t,
}

local function get_todos_file()
  local todos_file = vim.fn.stdpath 'data' .. '/todos.txt'
  return todos_file
end
