-- I want to creat a command which:
-- attaches to te current buffer, runs the curerent file,
-- and displays the ouput in a new buffer to the right of the current buffer.
-- I want to be able to run this command from the command line,
-- or from a keybinding.

-- If it is the first time the command is run, it will ask for the command to run.
-- i.e. "python", "node", "bash", etc.
-- If it is not the first time, it will use the last command used.

-- Helpers
local h = {
  write_to_buf = vim.api.nvim_buf_set_lines,

  new_buf = function()
    vim.cmd.new()
    return vim.api.nvim_get_current_buf()
  end,

  get_path = function(bufnr)
    if not bufnr then
      return vim.api.nvim_buf_get_name(0)
    end

    return vim.api.nvim_buf_get_name(bufnr)
  end,

  get_file_name = function(path)
    return path:match '([^/]+)$'
  end,
}

local group = vim.api.nvim_create_augroup('j0rdi-autorun', { clear = true })

local attach_to_buffer = function(bufnr, command)
  local output_buf = h.new_buf()
  vim.cmd.wincmd 'p'

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = '*.py',
    callback = function()
      local function append_data(_, data)
        if data then
          h.write_to_buf(output_buf, -1, -1, false, data)
        end
      end

      local file_name = h.get_file_name(h.get_path(bufnr))
      h.write_to_buf(output_buf, 0, -1, false, { string.format('Running %s', file_name) })

      vim.fn.jobstart({ command, h.get_path() }, {
        stdout_buffered = true,
        on_stdout = append_data,
        on_stderr = append_data,
      })
    end,
  })
end

vim.api.nvim_create_user_command('PyAutoRunOnSave', function()
  -- local command = vim.fn.input 'Command to run: '
  attach_to_buffer(vim.api.nvim_get_current_buf(), 'python')
end, {})

-- i want to make it more flexible, it will detect the file extension and run the correct command
-- for now it will just run python, node, ts-node, bash and lua.
-- i want to be able to run it from the command line, and from a keybinding.
-- also run it on demand or on save.
--
print(h.get_file_name(h.get_path()))

local function get_ext()
  local path = h.get_path()
  return path:match '%.([^.]+)$'
end

print(get_ext())

-- It seems like i can do it with plenary too, but i might just keep my own methods.
local file_extension = require('plenary.filetype').detect(h.get_path(), {})
print(file_extension)

local function get_command(ext)
  local commands = {
    py = 'python',
    lua = 'lua',
    js = 'node',
    ts = 'ts-node',
    sh = 'bash',
  }

  return commands[ext]
end

local function run_file()
  local ext = get_ext()
  local command = get_command(ext)

  if not command then
    print('No command found for extension: ' .. ext)
    return
  end

  attach_to_buffer(vim.api.nvim_get_current_buf(), command)
end

-- Command test
vim.api.nvim_create_user_command('AutoRunOnSave', function() end, {})

-- Global function
function CurrBuf()
  vim.notify(tostring(vim.api.nvim_get_current_buf()), vim.log.levels.WARN)
end

-- local class = {
--   field = 'Jordi',
--   method = function(self, a, b, c)
--     print(a, b, c)
--     print(self.field)
--   end,
-- }
--
-- class:method(unpack { 'j', 'k', 'l' })
--
-- local function multiple_returns()
--   return 'string', 10
-- end
--
-- local r1, r2 = multiple_returns()
--
-- print(r1, r2)

-- vim.api.nvim_create_user_command('PyAutoRun', {
--   nargs = '1',
--   func = function(_, args)
--     print('User function with args: ' .. args)
--   end,
--   -- nargs = '1',
--   -- args = { 'command' },
--   -- complete = 'command',
--   -- func = function(_, args)
--   --   if args[1] then
--   --     command = args
--   --   end
--   --
--   --   if not output_buf then
--   --     output_buf = vim.api.nvim_create_buf(false, true)
--   --     vim.api.nvim_set_current_buf(output_buf)
--   --     vim.api.nvim_command 'vsplit'
--   --     vim.api.nvim_set_current_buf(0)
--   --   end
--   --
--   --   attach_to_buffer()
--   -- end,
-- }, {})
