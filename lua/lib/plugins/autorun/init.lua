local api = vim.api
local h = require('lib.plugins.helpers')

local M = {}

local augroup = api.nvim_create_augroup('AutoRun', { clear = true })

---@alias File { path: string, name: string, ext: string, type: string }
---@alias AutoCmd { id: number, event: string, pattern: string }

---@class State
---@field file File | nil
---@field output_buf number | nil
---@field command string[] | nil
---@field autocmds AutoCmd[]
---@field commands table<string, string[]>
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
  self:clear_autocmds()

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

local function write_header()
  h.write_to_buf(state.output_buf, {
    '---',
    'CMD: ' .. table.concat(state.command, ' '),
    'TIME: ' .. os.date('%c'),
    '---',
    '',
  })
end

local function execute()
  write_header()

  vim.fn.jobstart(state.command, {
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

  state:clear_autocmds()

  state.file = file
  state.command = state.commands[file.ext]
  table.insert(state.command, state.file.path)

  if not state.output_buf then
    state.output_buf = h.new_scratch_buf({ name = 'autorun', direction = 'horizontal' })
  end

  write_header()
  execute()

  state:create_autocmd('BufDelete', 'autorun', function()
    M.detach()
    print('BUF:' .. state.output_buf .. ' DELETED')
  end)

  state:create_autocmd('BufWritePost', state.file.path, function()
    execute()
    print(state)
  end)
  state:create_autocmd('BufDelete', state.file.path, M.detach)
end

function M.detach()
  if state.output_buf then
    api.nvim_buf_delete(state.output_buf, { force = true })
  end

  state:reset()

  print('<<DETACHED>>')
end

---@type State
local initial_state = {
  file = nil,
  output_buf = nil,
  command = nil,
  autocmds = {},
  commands = {
    py = { 'python' },
    ts = { 'bun', 'run' },
    js = { 'bun', 'run' },
    -- lua = { 'luajit' },
  },
}

---@param config? { commands: table<string, string[]> }
function M.setup(config)
  state = State:new(initial_state)

  if config ~= nil then
    state.commands = require('utils').merge(state.commands, config.commands)
  end

  api.nvim_create_user_command('Run', M.attach, {})
end

return M
