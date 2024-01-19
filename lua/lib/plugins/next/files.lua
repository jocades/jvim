--- how to create and write to a file in lua?

local content = 'Hello World!'

-- create a file in the current directory
local f = io.open('test.txt', 'w')

if not f then
  error('Could not open file')
end

-- write 'content' to the file
f:write(content)

-- close the file
f:close()

-- open the file that was just written
f = io.open('test.txt', 'r')

if not f then
  error('Could not open file')
end

-- read the file content
local read_content = f:read('*all')
print(read_content)

-- close the opened file
-- f:close()

for line in io.lines('test.txt') do
  print(line)
end
