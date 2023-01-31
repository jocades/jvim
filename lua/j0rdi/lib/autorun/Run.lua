local ft = require 'plenary.filetype'
local h = require 'j0rdi.lib.helpers'
local Job = require 'plenary.job'

local group = vim.api.nvim_create_augroup('j0rdi-autorun', { clear = true })

local attach_to_buffer = function(bufnr, command, pattern, run_once)
  local state = {
    output_buf = nil,
    command = command,
    file_name = h:get_file_name(),
    pattern = pattern,
  }

  state.output_buf = h:new_nofile_buf 'AutoRun'
  vim.cmd.wincmd 'p'
  h:write_to_buf(state.output_buf, 0, -1, false, { string.format('- Running %s:', state.file_name), '' })

  local inform = string.format('Attached to: %s. Pattern: %s', state.file_name, state.pattern)
  print(inform)

  local function append_data(_, data)
    if data then
      h:write_to_buf(state.output_buf, -1, -1, false, data)
    end
  end

  local function run_job()
    local path = h:get_file_path()
    vim.fn.jobstart({ state.command, path }, {
      stdout_buffered = true,
      on_stdout = append_data,
      on_stderr = append_data,
    })
  end

  if not run_once then
    local id = vim.api.nvim_create_autocmd('BufWritePost', {
      group = group,
      pattern = state.pattern,
      callback = function()
        if not state.output_buf then
          state.output_buf = h:new_nofile_buf 'AutoRun'
          vim.cmd.wincmd 'p'
        end

        h:write_to_buf(state.output_buf, 0, -1, false, { string.format('- Running %s:', state.file_name), '' })
        run_job()
      end,
    })

    -- detach when buffer is closed
    vim.api.nvim_create_autocmd('BufWipeout', {
      group = group,
      pattern = state.pattern,
      callback = function()
        vim.api.nvim_del_autocmd(id)
        vim.api.nvim_buf_delete(state.output_buf, { force = true })
        print('Detached from: ' .. h:get_file_name())
        return true
      end,
    })
    -- reset when output buffer is closed
    vim.api.nvim_create_autocmd('BufWipeout', {
      group = group,
      pattern = 'AutoRun',
      callback = function() state.output_buf = nil end,
    })
  else
    run_job()
  end
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
  local command, ext = init()
  local pattern = '*.' .. ext
  local buf = h:get_curr_buf()

  if c.args == 'stop' then
    vim.api.nvim_del_autocmd(group)
    vim.api.nvim_buf_delete(buf, { force = true })
    return
  end

  if c.args == '' then
    attach_to_buffer(buf, command, h:get_file_path(), true)
  elseif c.args == 'watch' then
    attach_to_buffer(buf, command, pattern, false)
  elseif c.args == 'pattern' then
    pattern = vim.fn.input 'Pattern: '
    attach_to_buffer(buf, command, pattern, false)
  else
    h:print_err('Invalid argument: ' .. c.args)
  end
end, { nargs = '?' })
