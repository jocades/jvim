-- I want to creat a command which:
-- attaches to te current buffer, runs the curerent file,
-- and displays the ouput in a new buffer to the right of the current buffer.
-- I want to be able to run this command from the command line,
-- or from a keybinding.

-- If it is the first time the command is run, it will ask for the command to run.
-- i.e. "python", "node", "bash", etc.
-- If it is not the first time, it will use the last command used.

-- It seems like i can do it with plenary too, but i might just keep my own methods.
-- local file_extension = require('plenary.filetype').detect(get_path(), {})
--
local h = require 'j0rdi.lib.helpers'
local group = vim.api.nvim_create_augroup('j0rdi-autorun', { clear = true })

local function get_buf_info(string)
  local bufnr = vim.api.nvim_get_current_buf()

  return {
    path = vim.fn.expand '%:p',
    name = vim.fn.expand '%:t',
    ext = vim.fn.expand '%:e',
  }
end

print(get_buf_info().name, get_buf_info().ext, get_buf_info().path)

local attach_to_buffer = function(bufnr, command)
  local state = {
    output_buf = nil,
    command = command,
    file_name = vim.fn.expand '%:t',
    pattern = '*.' .. h:get_file_ext(),
    files = {},
  }

  local inform = string.format('Attached to: %s. Pattern: %s', state.file_name, state.pattern)
  print(inform)

  local function append_data(_, data)
    if data then
      h:write_to_buf(state.output_buf, -1, -1, false, data)
    end
  end

  local id = vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = state.pattern,
    callback = function()
      if not state.output_buf then
        state.output_buf = h:new_nofile_buf 'RunOnSave'
        vim.cmd.wincmd 'p'
      end

      h:write_to_buf(state.output_buf, 0, -1, false, { string.format('- Running %s:', state.file_name), '' })

      local path = h:get_file_path()

      vim.fn.jobstart({ state.command, path }, {
        stdout_buffered = true,
        on_stdout = append_data,
        on_stderr = append_data,
      })

      if not vim.tbl_contains(state.files, path) then
        table.insert(state.files, path)
      end
    end,
  })

  -- reset when output buffer is closed
  vim.api.nvim_create_autocmd('BufWipeout', {
    group = group,
    pattern = 'RunOnSave',
    callback = function() state.output_buf = nil end,
  })

  vim.api.nvim_create_autocmd('BufWipeout', {
    group = group,
    pattern = state.pattern,
    callback = function()
      -- check if we have any open bufs matching the pattern
      -- if not, delete the autocmd and the output buffer

      vim.api.nvim_del_autocmd(id)
      vim.api.nvim_buf_delete(state.output_buf, { force = true })
      print('Detached from: ' .. h:get_file_name())
      return true

      -- state.files = vim.tbl_filter(function(f) return f ~= h:get_file_path() end, state.files)
      --
      -- if vim.tbl_isempty(state.files) then
      --   vim.api.nvim_del_autocmd(id)
      --   vim.api.nvim_buf_delete(state.output_buf, { force = true })
      --   print('Detached from: ' .. h:get_file_name())
      -- end
    end,
  })
end

local function init()
  local ext = h:get_file_ext()
  local command = h:get_command(ext)

  if not command then
    print('No command found for extension: ' .. ext)
    return
  end

  return command, ext
end

vim.api.nvim_create_user_command('Run', function(c)
  if c.args == 'watch' then
    print 'watch'
    return
  end

  local command = init()

  attach_to_buffer(h:get_curr_buf(), command)
end, { nargs = '?' })

-- how can i pass arguments to the user command?
vim.api.nvim_create_user_command('Args', function(c)
  if c.args == 'watch' then
    print 'watch'
    return
  end
end, { nargs = 1 })

-- Global function
function CurrBuf() vim.notify(tostring(vim.api.nvim_get_current_buf()), vim.log.levels.WARN) end
function CurrWin() vim.notify(tostring(vim.api.nvim_get_current_win()), vim.log.levels.WARN) end
function CurrFile() vim.notify(tostring(vim.api.nvim_buf_get_name(0)), vim.log.levels.WARN) end
function CurrFileExt() vim.notify(tostring(vim.api.nvim_buf_get_name(0):match '%.([^.]+)$'), vim.log.levels.WARN) end

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
