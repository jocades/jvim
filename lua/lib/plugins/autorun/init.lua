local api = vim.api
local h = require('utils.api')
local log = require('utils.log')

local M = {}

local augroup = api.nvim_create_augroup('AutoRun', { clear = true })

---@alias AutoCmd { id: number, event: string, pattern: string }
---@alias RunCommand string[] | fun(file: File): string[]

---@class State
---@field file File | nil
---@field output_buf number | nil
---@field command RunCommand | nil
---@field autocmds AutoCmd[]
---@field commands table<string, RunCommand>
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

function State:create_autocmd(event, pattern, callback)
  table.insert(self.autocmds, {
    id = api.nvim_create_autocmd(event, {
      group = augroup,
      pattern = pattern,
      callback = callback,
    }),
    event = event,
    pattern = pattern,
  })
end

function State:clear_autocmds()
  if #self.autocmds > 0 then
    for _, autocmd in ipairs(self.autocmds) do
      print(autocmd.id)
      api.nvim_del_autocmd(autocmd.id)
    end
    self.autocmds = {}
  end
end

function State:reset()
  self.file = nil
  self.output_buf = nil
  self.command = nil
  self.autocmds = {}
end

---@type State
local state = nil

function State:get_command()
  local command

  if type(self.command) == 'function' then
    command = self.command(state.file)
  elseif type(self.command) == 'table' then
    ---@type string[]
    command = self.command
    table.insert(command, self.file.path)
  else
    error('Invalid command type')
  end

  return command
end

---@param command string[]
local function write_header(command)
  h.write_to_buf(state.output_buf, {
    '---',
    'CMD: ' .. table.concat(command, ' '),
    'TIME: ' .. os.date('%c'),
    'EXIT: ...',
    '---',
    '',
  })
end

local function append_data(_, data)
  if data then
    h.write_to_buf(state.output_buf, data, { append = true })
  end
end

local function execute()
  local command = state:get_command()

  write_header(command)

  ---@diagnostic disable-next-line
  local start = vim.fn.reltime()

  vim.fn.jobstart(command, {
    -- stdout_buffered = true, -- wait until EOF to collect output
    on_stdout = append_data,
    on_stderr = append_data,
    on_exit = function(_, code)
      ---@diagnostic disable-next-line
      local elapsed = vim.fn.reltimefloat(vim.fn.reltime(start))
      api.nvim_buf_set_lines(state.output_buf, 3, 4, false, {
        string.format('EXIT: %s (%.3fs)', code, elapsed),
      })
    end,
  })
end

function M.attach()
  local file = h.get_curr_file()

  if not state.commands[file.ext] then
    log.error(string.format('No command found for: %s (%s)', file.ext, file.type))
    return
  end

  state.file = file
  state.command = state.commands[file.ext]

  if not state.output_buf then
    state.output_buf = h.new_scratch_buf({
      name = 'autorun',
      direction = 'horizontal',
      size = 0.2,
    })
  end

  execute()

  state:create_autocmd('BufWritePost', state.file.path, execute)
  state:create_autocmd('BufDelete', state.file.path, M.detach)
  state:create_autocmd('BufDelete', 'autorun', function()
    state:clear_autocmds()
    state.output_buf = nil
  end)
  -- state:create_autocmd('BufUnload', 'autorun', function() log.warn('Output buffer unloaded') end)
end

function M.detach()
  if state.output_buf then
    api.nvim_buf_delete(state.output_buf, { force = true })
  end

  state:clear_autocmds()
  state:reset()
end

---@type State
local initial_state = {
  file = nil,
  output_buf = nil,
  command = nil,
  autocmds = {},
  commands = {
    py = function(file) return { 'python', file.path } end,
    --[[ c = function(file)
      local out = file.dir .. '/' .. file.stem

      return { 'gcc', file.path, '-o', out, '&&', out }
    end, ]]
  },
}

---@param config? { commands: table<string, string[] | fun(): string[]> }
function M.setup(config)
  state = State:new(initial_state)

  if config ~= nil and config.commands ~= nil then
    state.commands = require('utils').merge(state.commands, config.commands)
  end

  api.nvim_create_user_command('Run', function() M.attach() end, {})

  api.nvim_create_user_command('Stop', function() M.detach() end, {})

  api.nvim_create_user_command('RunInfo', function() P(state) end, {})
end

return M
