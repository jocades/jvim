local h = require('utils.api')
local str = require('utils.str')
local ls = require('luasnip')
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

function M.setup()
  vim.api.nvim_create_user_command('Nx', function(opts)
    P(opts)
    local args = str.split(opts.args)

    if #args ~= 2 then
      log.error('Use: Nx <file_type> <file_name>')
    end

    local file_types = { 'page', 'layout', 'error' }

    local file_type, file_name = args[1], args[2]

    if not vim.tbl_contains(file_types, file_type) then
      log.error('Invalid file type <' .. file_type .. '>')
    end

    local p = Path:new(vim.fn.getcwd())

    for x in p.iterdir() do
      if x.is_dir() and x.name == 'lua' then
        print(x)
        for y in x.iterdir() do
          if y.is_dir() and y.name == 'lib' then
            print('FOUND LIB');
            (y / 'pages').mkdir()
            local file = y / 'pages' / file_name
            file.touch()
            file.write({
              'export function ' .. file_name:sub(1, 1):upper() .. file_name:sub(2) .. 'Page() {',
              '\treturn <div>' .. file_name .. '</div>',
              '}',
            })

            break
          end
        end
      end
    end
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
