local h = require('lib.plugins.helpers')

local M = {}

local augroup = vim.api.nvim_create_augroup('AutoRun', { clear = true })

---@class State
---@field file { path: string, name: string, ext: string, type: string } | nil
---@field output_buf number | nil
---@field command string[] | nil
---@field autocmds { id: number, event: string, pattern: string, }[]
local State = {
  ---@param o State
  new = function(self, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
  end,

  __tostring = function(self) return vim.inspect(self) end,
}

function State:reset()
  self.file = nil
  self.output_buf = nil
  self.command = nil
  self.autocmds = {}
end

function State:create_autocmd(event, pattern, callback)
  table.insert(self.autocmds, {
    id = vim.api.nvim_create_autocmd(event, {
      group = augroup,
      pattern = pattern,
      callback = callback,
    }),
    event = event,
    pattern = pattern,
  })
end

local config = {
  file = nil,
  output_buf = nil,
  command = nil,
  autocmds = {},
}

local state = State:new(config)

local commands = {
  py = { 'python' },
  ts = { 'bun', 'run' },
  js = { 'bun', 'run' },
}

local function append_data(_, data)
  if data then
    h.write_to_buf(state.output_buf, data, { append = true })
  end
end

local function on_save()
  print(state)

  if not state.output_buf then
    state.output_buf = h.new_scratch_buf(true)

    state:create_autocmd('BufDelete', '<buffer=' .. state.output_buf .. '>', function()
      state.output_buf = nil
      print('BUF:' .. state.output_buf .. ' DELETED')
    end)
  end

  h.write_to_buf(state.output_buf, { '<<RUNNING ' .. state.file.name .. '>>' })

  vim.fn.jobstart(state.command, {
    stdout_buffered = true, -- send ouput one line at a time
    on_stdout = append_data,
    on_stderr = append_data,
  })
  -- vim.fn.jobwait({ job_id }, 1000)
end

function M.attach()
  local file = h.get_curr_file()

  if not commands[file.ext] then
    h.print_err(string.format('No command found for: %s (%s)', state.file.ext, state.file.type))
    return
  end

  state.file = file
  state.command = commands[file.ext]
  table.insert(state.command, state.file.path)

  state:create_autocmd('BufWritePost', state.file.path, on_save)
  state:create_autocmd('BufDelete', state.file.path, function() M.detach() end)
end

function M.detach()
  for _, autocmd in ipairs(state.autocmds) do
    vim.api.nvim_del_autocmd(autocmd.id)
  end

  if state.output_buf then
    vim.api.nvim_buf_delete(state.output_buf, { force = true })
  end

  state:reset()

  print('<<DETACHED>>')
end

return M
