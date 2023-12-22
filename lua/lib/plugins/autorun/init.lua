local api = vim.api
local h = require('lib.plugins.helpers')

local M = {}

local augroup = api.nvim_create_augroup('AutoRun', { clear = true })

---@alias File { path: string, name: string, ext: string, type: string }
---@alias AutoCmd { id: number, event: string, pattern: string }

---@class State
---@field file File | nil
---@field output_buf number | nil
---@field command nil | string[] | fun(): string[]
---@field autocmds AutoCmd[]
---@field commands table<string, string[] | fun(): string[]>
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
      api.nvim_del_autocmd(autocmd.id)
    end
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

local function append_data(_, data)
  if data then
    h.write_to_buf(state.output_buf, data, { append = true })
  end
end

function State:get_command()
  local command

  if type(self.command) == 'function' then
    command = self.command()
  elseif type(self.command) == 'table' then
    ---@type string[]
    command = self.command
  else
    error('Invalid command type')
  end

  command = vim.deepcopy(command)
  table.insert(command, self.file.path)

  return command
end

---@param command string[]
local function write_header(command)
  h.write_to_buf(state.output_buf, {
    '---',
    'CMD: ' .. table.concat(command, ' '),
    'TIME: ' .. os.date('%c'),
    '---',
    '',
  })
end

local function execute()
  local command = state:get_command()

  write_header(command)

  vim.fn.jobstart(command, {
    stdout_buffered = true, -- send ouput one line at a time
    on_stdout = append_data,
    on_stderr = append_data,
  })
end

function M.attach()
  local file = h.get_curr_file()

  if not state.commands[file.ext] then
    h.print_err(string.format('No command found for: %s (%s)', file.ext, file.type))
    return
  end

  state.file = file
  state.command = state.commands[file.ext]

  if not state.output_buf then
    state.output_buf = h.new_scratch_buf({ name = 'autorun', direction = 'vertical' })
  end

  execute()

  state:create_autocmd('BufWritePost', state.file.path, execute)
  state:create_autocmd('BufDelete', state.file.path, M.detach)
  state:create_autocmd('BufDelete', 'autorun', M.detach)
end

function M.detach()
  state:clear_autocmds()

  if state.output_buf then
    api.nvim_buf_delete(state.output_buf, { force = true })
  end

  state:reset()
end

---@type State
local initial_state = {
  file = nil,
  output_buf = nil,
  command = nil,
  autocmds = {},
  commands = {
    py = function() return { 'python' } end,
    --[[ c = function()
      -- compile and run with debug symbols
      return { 'gcc', '-Wall', '-Wextra', '-Werror', '-pedantic', '-std=c99', '-o', 'a.out', '&&', './a.out' }
    end, ]]
  },
}

---@param config? { commands: table<string, string[] | fun(): string[]> }
function M.setup(config)
  state = State:new(initial_state)

  if config ~= nil and config.commands ~= nil then
    state.commands = require('utils').merge(state.commands, config.commands)
  end

  api.nvim_create_user_command('Run', function()
    state:clear_autocmds()
    M.attach()
  end, {})
end

return M
