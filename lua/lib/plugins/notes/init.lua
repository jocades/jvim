local Path = require('lib.path')
local str = require('utils.str')
local u = require('utils')

local M = {}

local root = Path('lua/lib/plugins/notes')
local test = root / 'test.md'
local calendar = root / 'calendar'

local augroup = vim.api.nvim_create_augroup('Notes', { clear = true })

-- ---
-- x: project name
-- y: meta
-- ---

---@param file P
local function getMetadata(file)
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

local function now()
  local date = os.date('*t')
  return {
    date = string.format('%d-%02d-%02d', date.year, date.month, date.day),
    time = string.format('%02d:%02d:%02d', date.hour, date.min, date.sec),
  }
end

---@param file P
local function find_links(file)
  -- find all the text inside [[other_file_name]]
  -- find all the files that are linked to the current file

  local links = {}
  for line in file.lines() do
    for link in line:gmatch('%[%[(.-)%]%]') do
      table.insert(links, link)
    end
  end

  return links
end

local function open_note(path)
  -- escape the '$' char
  local cmd = string.format('%s/\\%s', path.parent().abs, path.name)
  vim.cmd.e(cmd)
  -- vim.api.nvim_buf_add_highlight(0, -1, 'Todo', 1, 0, -1)
  -- set the cursor to the last char of the last line and enter insert mode
  vim.cmd('normal G$')
  -- vim.cmd('startinsert')
  -- check for links when we exit the insert mode
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = augroup,
    pattern = path.abs,
    callback = function()
      -- find all the links in the current file
      local links = find_links(path)
      P(links)
    end,
  })
end

local links = find_links(test)
P(links)

local function generate_notename(number, title) return string.format('$%02d_%s.md', number, title or 'note') end

local function is_note(pathname) return pathname:match('^%$%d+_.+%.md$') and true or false end

local function createNote(title, opts)
  local ts = now()
  local today = calendar / ts.date

  local text = {
    '---',
    'title: ' .. (title or ''),
    'date: ' .. ts.date .. ' ' .. ts.time,
    '---',
  }

  local is_todo = table.includes(opts, '-t')

  if is_todo then
    for _, line in ipairs({ '', '# TODO:', '', '- [ ] Task' }) do
      table.insert(text, line)
    end
  end

  -- if not exists then create the file with the first note
  if not today.exists() then
    today.mkdir()
    local file = today / generate_notename(1, title)
    file.write(text)
    open_note(file)
    return
  end

  local last
  for node in today.iterdir() do
    if is_note(node.name) then
      last = node
    end
  end

  local last_n = tonumber(last.name:match('(%d+)'))
  local file = today / generate_notename(last_n + 1, title)
  file.write(text)
  open_note(file)
end

-- createNote()

function M.setup()
  print('Setting up the plugin NOTES')
  vim.api.nvim_create_user_command('Today', function(opts)
    local command = opts.args == '' and nil or str.split(opts.args)

    if not command then
      createNote()
      return
    end

    P(command)

    -- -t = todos template

    local args = u.reduce(command, function(acc, v)
      if v:sub(1, 1) ~= '-' then
        table.insert(acc, v)
      end
      return acc
    end, {})
    P(args)

    local options = u.reduce(command, function(acc, v)
      if v:sub(1, 1) == '-' then
        table.insert(acc, v)
      end
      return acc
    end, {})
    P(options)

    local title = #args == 0 and nil or args[1]
    createNote(title, options)

    -- local title = #opts.fargs == 0 and nil or opts.fargs[1]
    -- print('Creating a new note with title:', title)
    -- createNote(title)
  end, {
    nargs = '?',
  })
end

M.setup()

return M
