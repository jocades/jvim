local Path = require('lib.path')
local str = require('utils.str')
local event = require('nui.utils.autocmd').event
local Input = require('lib.plugins.ui.input')
local Menu = require('lib.plugins.ui.menu')
local Picker = require('lib.plugins.ui.picker')
local tsu = require('nvim-treesitter.ts_utils')
local class = require('lib.class')
local Popup = require('lib.plugins.ui.popup')
local h = require('utils.api')
local templates = require('lib.plugins.notes.templates')

local M = {}

local DATA_PATH = Path('~/.local/data/notes')
local TEST_PATH = Path('~/.config/nvim/lua/lib/plugins/notes/test')
local TEST = false

local augroup = vim.api.nvim_create_augroup('Notes', { clear = true })

---@alias Timestamp { date: string, time: string, day: string, month: string }

local function format_date(date)
  return string.format('%d-%02d-%02d', date.year, date.month, date.day)
end

local function format_time(date)
  return string.format('%02d:%02d:%02d', date.hour, date.min, date.sec)
end

local function now()
  local date = os.date('*t')
  return {
    date = format_date(date),
    time = format_time(date),
    day = os.date('%A'),
    month = os.date('%B'),
  }
end

local function ms_to_date(ms)
  local date = os.date('*t', ms)
  return string.format('%s | %s', format_date(date), format_time(date))
end

---@param filename string
local function md(filename) return filename .. '.md' end

---@class NState
---@overload fun(): NState
---@field popup NuiPopup
local State = class()

function State:new()
  self.data_path = TEST and TEST_PATH or DATA_PATH
  self.dir = nil
  self.mounted = false
  self.popup = nil
end

---@param opts? { data_path: string }
function State:setup(opts)
  opts = opts or {}

  if opts.data_path ~= nil then self.data_path = Path(opts.data_path) end
end

---@param opts { type: 'calendar' | 'idea' }
function State:set_dir(opts)
  if opts.type == 'calendar' then
    self.dir = self.data_path / 'calendar' / now().date
  elseif opts.type == 'idea' then
    self.dir = self.data_path / 'idea'
  end
end

local state = State()

local function generate_notename(title)
  return md(table.concat(str.split(title), '-'))
end

local function is_note(pathname)
  return pathname:match('%.md$') and true or false
end

---@param path P | string
---@param opts? { start_insert: boolean }
M.open_note = function(path, opts)
  opts = opts or {}

  if type(path) == 'string' then path = Path(path) end

  vim.cmd.e(path.abs)

  if opts.start_insert then
    vim.cmd('normal G$')
    vim.cmd('startinsert')
  end
end

---@param title string
---@param opts? { type: 'calendar' | 'idea', template?: 'blank' | 'todo' }
M.create_note_file = function(title, opts)
  opts = opts or {}

  if opts.type ~= nil then state:set_dir(opts) end

  local template = opts.template or 'blank'

  local text = templates.header({ name = title, ts = now() })

  if template == 'todo' then
    table.extend(text, templates.todo)
  else
    table.insert(text, '')
  end

  if not state.dir.exists() then state.dir.mkdir({ parents = true }) end

  local file = state.dir / generate_notename(title)
  file.write(text)
  M.open_note(file, { start_insert = true })
end

---@param opts { type: 'calendar' | 'idea', template?: 'blank' | 'todo' }
M.create_note = function(opts)
  state:set_dir(opts)

  local input = Input({
    title = str.capitalize(opts.type),
    on_submit = function(title) M.create_note_file(title, opts) end,
  })
  input:mount()
  input:on(event.BufLeave, function() input:unmount() end)
end

---@param paths P[]
local function sort_by_last_modified(paths)
  table.sort(paths, function(x, y) return x.mtime > y.mtime end)
end

---@param value string | nil
local function on_select(value)
  if not value then return end
  local filename = md(str.trim(str.split(value, '|')[1]))
  M.open_note(state.dir / filename)
end

---@param opts { type: 'calendar' | 'idea' }
function M.list_notes(opts)
  state:set_dir(opts)

  if not state.dir.is_dir() then return end

  local notes = state.dir.children()
  sort_by_last_modified(notes)

  local items = table.map(
    notes,
    function(note)
      return string.format('%s | %s', note.stem, ms_to_date(note.mtime))
    end
  )

  Picker({
    title = (function()
      if opts.type == 'calendar' then return 'Calendar' end
      return 'Ideas'
    end)(),
    items = items,
    on_select = on_select,
    keymaps = {
      { 'n', 'n', function() M.create_note({ type = 'calendar' }) end },
      { 'n', 'q', function() vim.cmd('q') end },
      { 'i', '<C-n>', function() M.create_note({ type = 'calendar' }) end },
    },
  })
end

---@param file P
---@return string[]
local function find_links(file)
  local links = {}
  for link in file.read():gmatch('%[([^%]]+)%]') do
    table.insert(links, link)
  end
  return links
end

---@param file P
local function show_links(file)
  local links = find_links(file)
  h.write_to_buf(
    state.popup.bufnr,
    table.map(links, function(link)
      local p = state.dir / md(link)
      if p.exists() then return link .. ' [exists]' end
      return link .. ' [not found]'
    end)
  )
end

---@param path P
local function attach_listeners(path)
  local autocmds = {}

  -- check for links when we save the file
  table.insert(
    autocmds,
    vim.api.nvim_create_autocmd(event.BufWritePost, {
      group = augroup,
      pattern = path.abs,
      callback = function()
        state.popup:show()
        show_links(path)
      end,
    })
  )

  table.insert(
    autocmds,
    vim.api.nvim_create_autocmd({ event.BufDelete, event.BufLeave }, {
      group = augroup,
      pattern = path.abs,
      callback = function()
        print('BufDelete')
        state.popup:unmount()
        state.mounted = false
      end,
    })
  )

  -- remove the autocmd when the buffer is closed
  --[[ vim.api.nvim_create_autocmd({ event.BufDelete, event.BufLeave }, {
    group = augroup,
    pattern = path.abs,
    callback = function()
      table.for_each(autocmds, function(id) vim.api.nvim_del_autocmd(id) end)
    end,
  }) ]]
end

local function set_keymaps(buf)
  vim.keymap.set('n', '<leader>l', function()
    local node = tsu.get_node_at_cursor()

    if not node then return end
    if node:type() == 'link_text' then node = node:parent() end
    if node:type() ~= 'shortcut_link' then return end

    local link = tsu.get_node_text(node)[1]
    link = link:gsub('%[', ''):gsub('%]', '')

    local path = Path(state.dir / md(link))

    if not path.exists() then
      M.create_note_file(link)
    else
      M.open_note(path)
    end
  end, { buffer = buf })
end

M.open_today_todo = function()
  state:set_dir({ type = 'calendar' })
  local file = state.dir / generate_notename('todo')
  if not file.exists() then
    M.create_note_file('todo', { type = 'calendar', template = 'todo' })
  end
  M.open_note(file, { start_insert = true })
end

---@param opts? { data_path: string }
M.setup = function(opts)
  state:setup(opts)

  vim.api.nvim_create_autocmd(event.BufEnter, {
    group = augroup,
    pattern = state.data_path.abs .. '/**/*.md',
    callback = function()
      local path = Path(vim.api.nvim_buf_get_name(0))
      local buf = vim.api.nvim_get_current_buf()

      state.dir = path:parent()

      if not state.mounted then
        state.popup = Popup.bottom_right()
        state.popup:mount()
        state.mounted = true
      end

      set_keymaps(buf)
      show_links(path)
      attach_listeners(path)
    end,
  })

  vim.api.nvim_create_user_command('NotesInfo', function()
    local buf = h.new_floating_win()
    h.write_to_buf(buf, str.split(vim.inspect(state), '\n'))
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>q<cr>', { noremap = true })
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  end, {})

  vim.api.nvim_create_user_command('Today', function(opts)
    local command = (function()
      if opts.args == '' then return nil end
      return str.split(opts.args)
    end)()

    if not command then
      M.create_note_today()
      return
    end

    local args = table.reduce(command, function(acc, v)
      if v:sub(1, 1) ~= '-' then table.insert(acc, v) end
      return acc
    end, {})

    local options = table.reduce(command, function(acc, v)
      if v:sub(1, 1) == '-' then table.insert(acc, v) end
      return acc
    end, {})

    local title = #args == 0 and nil or args[1]

    M.create_note_file(title, {
      template = table.includes(options, '-t') and 'todo' or 'blank',
    })
  end, {
    nargs = '?',
  })
end

-- yaml frontmatter
-- ---
-- x: project name
-- y: meta
-- ---

---@param file P
local function get_metadata(file)
  local lines = file.readlines() -- -> { '---', 'x: project name', 'y: meta', '---' }
  local metadata = {}
  for i = 2, #lines - 1 do
    local line = lines[i]
    local key, value = line:match('(%w+):%s*(.+)')
    metadata[key] = value
  end
  return metadata
end

-- local metadata = getMetadata(root / 'test.md')

-- local dir = root / table.concat(str.split(metadata.x), '_')
--
-- if not dir.exists() then
--   dir.mkdir()
-- end

-- CALENDAR
-- add command like: :Today, to insert a new note with the current date

return M
