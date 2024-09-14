local tmux = require("lib.tmux")
local tsu = require("nvim-treesitter.ts_utils")

local M = {}

local function create_key(entry)
  assert(entry.Package, "Must have Package:" .. vim.inspect(entry))
  assert(entry.Test, "Must have Test:" .. vim.inspect(entry))
  return ("%s/%s"):format(entry.Package, entry.Test)
end

local function add_test(s, entry)
  s.tests[create_key(entry)] = {
    name = entry.Test,
    line = 0,
    output = {},
  }
end

local function parse_line(s, line)
  local ok, decoded = pcall(vim.json.decode, line)
  vim.print(ok, decoded)

  if not ok then
    return
  end

  if decoded.Action == "run" then
    add_test(s, decoded)
  end
end

local function execute(s)
  local command = ("go test %s -json"):format(vim.api.nvim_buf_get_name(s.buf))

  if not s.out then
    s.out = vim.api.nvim_create_buf(false, true)
    vim.cmd.vsplit()
    vim.api.nvim_set_current_buf(s.out)
  end

  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        return
      end

      for _, line in ipairs(data) do
        parse_line(s, line)
      end
    end,
    -- on_stderr = append_data(out_buf),
    on_exit = function(_, code) end,
  })
end

--[[ vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('jvim-go-test', { clear = true }),
  pattern = '*_test.go',
  callback = execute,
}) ]]

local function create_state()
  return {
    path = vim.api.nvim_buf_get_name(0),
    tests = {},
  }
end

-- Execute shell command using vim.fn.system
---@param exec string | table { string }
local function sys(exec, debug)
  if type(exec) == "table" then
    exec = table.concat(exec, " && ")
  end
  if debug then
    vim.print("Executing: " .. exec)
  end
  vim.fn.system(exec)
end

local function inspect(node)
  vim.print(getmetatable(node))
end

local function is_go_test(path)
  return path:match("_test.go$")
end

function M.go_test_func()
  local path = vim.api.nvim_buf_get_name(0)
  if not is_go_test(path) then
    return
  end

  local node = tsu.get_node_at_cursor()
  if not node then
    return
  end

  if
    node:type() == "identifier"
    and node:parent():type() == "function_declaration"
  then
    local text = tsu.get_node_text(node)[1]
    if text:sub(1, 4) == "Test" then
      vim.notify("Running test: " .. text)
      sys({
        tmux.select_pane("-l"),
        tmux.run({ "go", "test", "-v", path, "-run", text }),
        tmux.select_pane("-l"),
      })
    end
  end
end

vim.keymap.set("n", "<leader>rt", M.go_test_func, { desc = "Run Go Test" })

function M.go_test()
  local state = create_state()
  -- execute(state)
  sys({
    tmux.select_pane("-l"),
    tmux.run({ "go", "test", "-v", state.path }),
    tmux.select_pane("-l"),
  })
end

vim.api.nvim_create_user_command("GoTest", function()
  M.go_test()
end, {})

vim.api.nvim_create_user_command("GoTestFunc", function()
  M.go_test_func()
end, {})
