local api = vim.api
local h = require('utils.api')
local str = require('utils.str')
local log = require('utils.log')

local M = {}

local augroup = api.nvim_create_augroup('AutoRun', { clear = true })

---@alias AutoCmd { id: number, event: string, pattern: string }
---@alias RunCommand string[] | fun(file: File): string[]
---@alias RunConfig { commands: table<string, RunCommand>, output: { name: string } }

---@class State
---@field file File | nil
---@field output_buf { id: number, name: string } | nil
---@field autocmds AutoCmd[]
---@field command RunCommand | nil
---@field commands table<string, RunCommand>
---@field config RunConfig | nil
local State = {
  new = function(self, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
  end,

  __tostring = function(self) return vim.inspect(self) end,

  file = nil,
  output_buf = { name = 'autorun' },
  config = nil,
  autocmds = {},
  command = nil,
  commands = {
    py = function(file) return { 'python', file.path } end,
    c = function(file)
      local out = str.join({ file.dir, file.stem }, '/')
      return { 'gcc', file.path, '-o', out, '&&', 'echo', 'HELLO' }
    end,
  },
}

---@type State
local state = State:new()

---@param config? RunConfig
function State:setup(config)
  if not config then
    return
  end

  self.config = config

  if config.commands ~= nil then
    self.commands = require('utils').merge(self.commands, config.commands)
  end
  if config.output ~= nil then
    self.output_buf.name = config.output.name
  end
end

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
    self.autocmds = {}
  end
end

function State:delete_output_buf()
  if self.output_buf.id then
    api.nvim_buf_delete(state.output_buf.id, { force = true })
  end
end

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
  h.write_to_buf(state.output_buf.id, {
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
    h.write_to_buf(state.output_buf.id, data, { append = true })
  end
end

local function execute()
  local command = state:get_command()

  write_header(command)

  ---@diagnostic disable-next-line
  local start = vim.fn.reltime()

  vim.fn.jobstart(command, {
    on_stdout = append_data,
    on_stderr = append_data,
    on_exit = function(_, code)
      ---@diagnostic disable-next-line
      local elapsed = vim.fn.reltimefloat(vim.fn.reltime(start))
      api.nvim_buf_set_lines(state.output_buf.id, 3, 4, false, {
        string.format('EXIT: %s (%.3fs)', code, elapsed),
      })
    end,
  })
end

function M.attach()
  local file = h.File()

  if not state.commands[file.ext] then
    log.error(string.format('No command found for: %s (%s)', file.ext, file.type))
    return
  end

  state.file = file
  state.command = state.commands[file.ext]

  if not state.output_buf.id then
    state.output_buf.id = h.new_scratch_buf({
      name = state.output_buf.name,
      direction = 'horizontal',
      size = 0.25,
    })
  end

  execute()

  state:create_autocmd('BufWritePost', state.file.path, execute)
  state:create_autocmd('BufDelete', state.file.path, M.detach)
  state:create_autocmd('BufDelete', state.output_buf.name, function()
    state:clear_autocmds()
    state.output_buf.id = nil
  end)
end

function M.detach()
  state:delete_output_buf()
  state:clear_autocmds()
  state.file = nil
  state.command = nil
  state.output_buf.id = nil
  state.autocmds = {}
end

function M.show_info()
  local buf, _ = h.new_floating_win()
  h.write_to_buf(buf, str.split(vim.inspect(state), '\n'))
  api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>q<cr>', { noremap = true })
  -- no not allow insert mode
  api.nvim_buf_set_option(buf, 'modifiable', false)
end

---@param config RunConfig
function M.setup(config)
  state:setup(config)
  api.nvim_create_user_command('Run', M.attach, {})
  api.nvim_create_user_command('Stop', M.detach, {})
  api.nvim_create_user_command('RunInfo', M.show_info, {})
end

return M
