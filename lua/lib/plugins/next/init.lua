local h = require('utils.api')
local str = require('utils.str')
local log = require('utils.log')
local Path = require('lib.path')

local M = {}

function M.run()
  local file = h.File()

  local dirs = file.split()

  local dir = '/'

  for i = 1, #dirs do
    dir = dir .. dirs[i] .. '/'
    if dirs[i] == 'lua' then
      break
    end
  end

  print('dir', dir)

  local input = h.File(vim.fn.input('Enter file name: '))

  print(vim.inspect(input))

  local folders = input.split()

  if #folders > 1 then
    local file_name = table.remove(folders, #folders)
    print('file_name', file_name)
    P(folders)
    dir = dir .. table.concat(folders, '/')
    print('dir', dir)
    if vim.fn.isdirectory(dir) then
      print('mkdir')
      vim.fn.mkdir(dir, 'p')
    end
    vim.cmd('e ' .. dir .. '/' .. file_name)
    -- h.write_to_buf(h.get_curr_buf(), {
    --   'hello world',
    -- })

    -- how to trigger a snippet?
  end
end

-- hello -> Hello
-- hello-world -> HelloWorld
local function to_camel_case(s)
  local parts = str.split(s, '-')

  local result = ''

  for _, v in ipairs(parts) do
    result = result .. str.capitalize(v)
  end

  return result
end

function M.setup()
  vim.api.nvim_create_user_command('Nx', function(opts)
    local args = str.split(opts.args)

    if #args ~= 2 then
      log.error('Use: Nx <file_type> <file_name>')
    end

    local file_types = { 'page', 'layout', 'error' }

    local file_type, file_name = args[1], args[2]

    if not vim.tbl_contains(file_types, file_type) then
      log.error('Invalid file type <' .. file_type .. '>')
    end

    local r = Path('lua/lib/src/app')
    local f = Path(file_name)

    if #f.parts > 1 then
      local dir = f.parent()

      if not dir.exists() then
        dir.mkdir({ parents = true })
      end
    end

    if not f.ext then
      f = Path(file_name .. '.tsx')
    end

    P(f)

    --[[ print('file_name', file_name)

    local p = Path('lua/lib')

    for x in p.iterdir() do
      if x.is_dir() and x.name == 'src' then
        print(x)
        for y in x.iterdir() do
          if y.is_dir() and y.name == 'app' then
            print('FOUND APP')

            local file = y.join(file_name .. '.tsx')

            if file.exists() then
              log.error('File already exists')
              break
            end

            local component_name = to_camel_case(file_name)

            file.write({
              'export default function ' .. component_name .. 'Page() {',
              '  return <div>' .. component_name .. '</div>',
              '}',
            })

            break
          end
        end
      end
    end ]]
  end, {
    nargs = '?',
  })
end

M.setup()

return M

-- local content = [[
--  print('Hello World')
-- ]]
--
-- local f = io.open(dir .. input, 'w')
--
-- if not f then
--   error('Could not open file')
-- end
--
-- -- write 'content' to the file
-- f:write(content)
--
-- f:close()
