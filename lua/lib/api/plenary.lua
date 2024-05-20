local walk = require('plenary.scandir')
local Path = require('plenary.path')
local Job = require('plenary.job')

local p = Path:new('.')
-- P(p)

local function get_files()
  local files = {}
  walk.scan_dir('.', {
    add_dirs = true,
    depth = 1,
    on_insert = function(entry, typ)
      if typ == 'file' then table.insert(files, entry) end
    end,
  })
  return files
end

-- P(get_files())

local function run()
  Job:new({
    command = 'python',
    cwd = '/Users/j0rdi/.config/nvim/lua/lib/plugins/autorun/test',
    -- args = {'-c', 'import sys; print(sys.argv[1])', 'hello'},
    args = { 'exec.py' },
    on_exit = function(j, return_val, code)
      print('return_val', return_val)
      print('code', code)
      P(j:result())
    end,
    on_stdout = function(err, data, j) print('stdout', data) end,
    on_stderr = function(err, data, j) print('stderr', data) end,
    stdout_buffered = true,
  }):start()
end

-- run()

local function raw()
  local job = vim.fn.jobstart({
    'python',
    'exec.py',
  }, {
    stdout_buffered = true,
    stderr_buffered = true,
    cwd = '/Users/j0rdi/.config/nvim/lua/lib/plugins/autorun/test',
    on_exit = function(_, _, _) print('exit') end,
    on_stdout = function(_, data, _) P(data) end,
    on_stderr = function(_, data, _) P(data) end,
  })
end

raw()
