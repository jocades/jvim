local Path = require('lib.path')
local str = require('utils.str')
local event = require('nui.utils.autocmd').event
local Input = require('lib.plugins.ui.input')
local Menu = require('lib.plugins.ui.menu')
local Picker = require('lib.plugins.ui.picker')
local ts_utils = require('nvim-treesitter.ts_utils')
local class = require('lib.class')
local Popup = require('lib.plugins.ui.popup')
local h = require('utils.api')

local M = {}

local DATA_PATH = '~/.local/data/notes'
local TEST = true

local root_dir = TEST and Path('~/.config/nvim/lua/lib/plugins/notes/test')
  or Path(DATA_PATH)

local test_file = root_dir / 'test.md'
local calendar_dir = root_dir / 'calendar'
local idea_dir = root_dir / 'idea'

local augroup = vim.api.nvim_create_augroup('Notes', { clear = true })

---@alias Timestamp { date: string, time: string, day: string, month: string }

local function now()
  local date = os.date('*t')
  return {
    date = string.format('%d-%02d-%02d', date.year, date.month, date.day),
    time = string.format('%02d:%02d:%02d', date.hour, date.min, date.sec),
    day = os.date('%A'),
    month = os.date('%B'),
  }
end

---@class NState
---@overload fun(): NState
local State = class()

function State:new() self.dir = calendar_dir end

---@param opts { type: 'calendar' | 'idea' }
function State:set_dir(opts)
  if opts.type == 'calendar' then
    self.dir = calendar_dir / now().date
  elseif opts.type == 'idea' then
    self.dir = idea_dir
  end
end

local state = State()

---@param file P
---@return string[]
local function find_links(file)
  -- find all the text inside [other_file_name]
  -- find all the files that are linked to the current file
  local links = {}
  for link in file.read():gmatch('%[([^%]]+)%]') do
    table.insert(links, link)
  end

  return links
end

local function show_links(file, buf)
  local links = find_links(file)
  h.write_to_buf(
    buf,
    table.map(links, function(link)
      local p = state.dir / (link .. '.md')
      if p.exists() then
        return link .. ' [exists]'
      end
      return link .. ' [not found]'
    end)
  )
end

---@param path P
---@param popup NuiPopup
local function attach_listeners(path, popup)
  local autocmds = {}

  -- check for links when we save the file
  table.insert(
    autocmds,
    vim.api.nvim_create_autocmd(event.BufWritePost, {
      group = augroup,
      pattern = path.abs,
      callback = function() show_links(path, popup.bufnr) end,
    })
  )

  table.insert(
    autocmds,
    vim.api.nvim_create_autocmd(event.BufLeave, {
      pattern = path.abs,
      callback = function() popup:hide() end,
    })
  )

  table.insert(
    autocmds,
    vim.api.nvim_create_autocmd(event.BufEnter, {
      pattern = path.abs,
      callback = function()
        print('buf enter')
        popup:show()
      end,
    })
  )

  -- remove the autocmd when the buffer is closed
  vim.api.nvim_create_autocmd(event.BufDelete, {
    group = augroup,
    pattern = path.abs,
    callback = function()
      table.for_each(autocmds, function(id) vim.api.nvim_del_autocmd(id) end)
    end,
  })
end

---@param path P | string
---@param opts? { start_insert: boolean }
local function open_note(path, opts)
  opts = opts or {}

  if type(path) == 'string' then
    path = Path(path)
  end

  vim.cmd.e(path.abs)

  if opts.start_insert then
    vim.cmd('normal G$')
    vim.cmd('startinsert')
  end

  local buf = vim.api.nvim_get_current_buf()

  M.set_keymaps(buf)

  local popup = Popup.bottom_right()
  popup:mount()

  show_links(path, popup.bufnr)
  attach_listeners(path, popup)
end

M.set_keymaps = function(buf)
  vim.keymap.set('n', '<leader>l', function()
    local node = ts_utils.get_node_at_cursor()

    if not node then
      print('No node found')
      return
    end

    print('type:', node:type())

    if node:type() == 'link_text' then
      node = node:parent()
      print('parent:', node:type())
    end

    if node:type() ~= 'shortcut_link' then
      print('Not a shortcut_link')
      return
    end

    local link = ts_utils.get_node_text(node)[1]

    print('link:', link)

    -- reomve the brackets
    link = link:gsub('%[', ''):gsub('%]', '')
    print('link:', link)

    local p = Path(state.dir / (link .. '.md'))
    print('path:', p)

    if not p.exists() then
      M.create_note_file(link, { type = 'idea' })
    end

    open_note(p)
  end, { buffer = buf })
end

--[[ local links = find_links(test)
P(links) ]]

local function generate_notename(number, title)
  return table.concat(str.split(title), '-') .. '.md'
end

local function is_note(pathname)
  return pathname:match('%.md$') and true or false
end

local templates = {
  ---@param opts { name: string, ts: Timestamp }
  header = function(opts)
    return {
      '---',
      'title: ' .. opts.name,
      'date: ' .. string.format(
        '%s | %s | %s',
        opts.ts.date,
        opts.ts.time,
        opts.ts.day
      ),
      '---',
      '',
    }
  end,
  todo = {
    '# TODO:',
    '',
    '- [ ] Task',
  },
}

---@param title string
---@param opts { type: 'calendar' | 'idea', template?: 'blank' | 'todo' }
M.create_note_file = function(title, opts)
  state:set_dir(opts)

  local template = opts.template or 'blank'

  local text = templates.header({ name = title, ts = now() })

  if template == 'todo' then
    table.extend(text, templates.todo)
  else
    table.insert(text, '')
  end

  if not state.dir.exists() then
    state.dir.mkdir({ parents = true })
  end

  local file = state.dir / generate_notename(1, title)
  file.write(text)
  open_note(file, { start_insert = true })
end

---@param opts { type: 'calendar' | 'idea', template?: 'blank' | 'todo' }
function M.create_note(opts)
  state:set_dir(opts)

  local input = Input({
    title = str.capitalize(opts.type),
    on_submit = function(title) M.create_note_file(title, opts) end,
  })
  input:mount()
  input:on(event.BufLeave, function() input:unmount() end)
end

---@param opts { type: 'calendar' | 'idea' }
function M.list_notes(opts)
  state:set_dir(opts)

  Picker({
    title = (function()
      if opts.type == 'calendar' then
        return 'Calendar'
      end
      return 'Ideas'
    end)(),
    items = table.map(
      state.dir.children(),
      function(note) return note.stem end
    ),
    on_select = function(value) open_note(state.dir / (value .. '.md')) end,
    keymaps = {
      { 'n', 'n', function() M.create_note({ type = 'calendar' }) end },
      { 'n', 'q', function() vim.cmd('q') end },
      { 'i', '<C-n>', function() M.create_note({ type = 'calendar' }) end },
    },
  })

  --[[ local menu = Menu({
    title = 'Today ("n": new note)',
    items = table.map(
      get_today_notes(),
      function(note) return { text = note.name, data = { path = note.abs } } end
    ),
    on_submit = function(item) open_note(item.path) end,
  })
  menu:map('n', 'n', function()
    menu:unmount()
    M.create_note_today()
  end)
  menu:mount()
  menu:on(event.BufLeave, function() menu:unmount() end) ]]
end

function M.setup()
  vim.api.nvim_create_user_command('Today', function(opts)
    local command = (function()
      if opts.args == '' then
        return nil
      end
      return str.split(opts.args)
    end)()

    if not command then
      M.create_note_today()
      return
    end

    local args = table.reduce(command, function(acc, v)
      if v:sub(1, 1) ~= '-' then
        table.insert(acc, v)
      end
      return acc
    end, {})

    local options = table.reduce(command, function(acc, v)
      if v:sub(1, 1) == '-' then
        table.insert(acc, v)
      end
      return acc
    end, {})

    local title = #args == 0 and nil or args[1]

    create_note_file(title, {
      template = table.includes(options, '-t') and 'todo' or 'blank',
    })
  end, {
    nargs = '?',
  })
end

-- M.setup()

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
