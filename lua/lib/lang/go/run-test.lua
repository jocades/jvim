local Popup = require("nui.popup")
local tmux = require("lib.tmux")
local tsu = require("nvim-treesitter.ts_utils")

local M = {}

local ns = vim.api.nvim_create_namespace("live-tests")
local group = vim.api.nvim_create_augroup("jvim-automagic", { clear = true })

local function make_key(entry)
  assert(entry.Package, "Must have Package:" .. vim.inspect(entry))
  assert(entry.Test, "Must have Test:" .. vim.inspect(entry))
  return ("%s/%s"):format(entry.Package, entry.Test)
end

local function add_test(s, entry)
  s.tests[make_key(entry)] = {
    name = entry.Test,
    line = 0,
    output = {},
  }
end

local function add_output(s, entry)
  table.insert(s.tests[make_key(entry)].output, vim.trim(entry.Output))
end

local function mark_success(s, entry)
  local test = s.tests[make_key(entry)]
  test.success = entry.Action == "pass"
  return test
end

local function parse_line(s, line)
  local ok, decoded = pcall(vim.json.decode, line)
  -- vim.print(ok, line, decoded)

  if not ok then
    return
  end

  if decoded.Action == "run" then
    add_test(s, decoded)
  elseif decoded.Action == "output" then
    add_output(s, decoded)
  elseif decoded.Action == "pass" or decoded.Action == "fail" then
    local test = mark_success(s, decoded)
    if test.success then
      local text = { "PASS" }
      vim.api.nvim_buf_set_extmark(s.buf, ns, test.line, 0, {
        virt_text = { text },
      })
    end
  end
end

local function append_data(buf, data)
  if not data then
    return
  end
  vim.api.nvim_buf_set_lines(buf, -2, -1, false, data)
end

--[[ vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('jvim-go-test', { clear = true }),
  pattern = '*_test.go',
  callback = execute,
}) ]]

local function create_popup(title)
  return Popup({
    relative = "editor",
    -- enter = true,
    focusable = true,
    position = {
      row = "90%",
      col = "99%",
    },
    size = {
      width = 50,
      height = 20,
    },
    border = {
      style = "rounded",
      text = {
        top = title,
        top_align = "center",
        bottom = "rerun (r) | close (q) | save (s)",
        bottom_align = "center",
      },
    },
    buf_options = {
      -- modifiable = false,
      -- readonly = true,
    },
  })
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

local function clear(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
end

---@type NuiPopup
local popup

---@param cmd string[]
local function execute(cmd)
  local state = {
    buf = vim.api.nvim_get_current_buf(),
    tests = {},
  }

  vim.fn.jobstart(table.concat(cmd, " "), {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        return
      end

      for _, line in ipairs(data) do
        parse_line(state, line)
      end
    end,
    -- on_stderr = append_data(popup.bufnr),
    -- on_stderr = append_data(out_buf),
    on_exit = function(_, code)
      vim.notify(vim.inspect(state))
      -- append_data(popup.bufnr, { vim.inspect(state.tests) })
    end,
  })
end

function M.go_test(path)
  if not popup then
    popup = create_popup()
  end

  popup:mount()

  execute({ "go", "test", "-json", path })

  -- sys({
  --   tmux.select_pane("-l"),
  --   tmux.run({ "go", "test", "-v", state.path }),
  --   tmux.select_pane("-l"),
  -- })
end

function M.go_test_func(path)
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
    local func = tsu.get_node_text(node)[1]
    if func:sub(1, 4) == "Test" then
      vim.notify("Running test: " .. func)
      execute({ "go", "test", "-v", path, "-run", func })
      --[[ sys({
        tmux.select_pane("-l"),
        tmux.run({ "go", "test", "-v", path, "-run", text }),
        tmux.select_pane("-l"),
      }) ]]
    end
  end
end

function M.setup()
  vim.api.nvim_create_user_command("GoTest", function()
    M.go_test(vim.api.nvim_buf_get_name(0))
  end, {})

  vim.api.nvim_create_user_command("GoTestFunc", function()
    M.go_test_func(vim.api.nvim_buf_get_name(0))
  end, {})

  vim.keymap.set("n", "<leader>gtr", vim.cmd.GoTest, { desc = "Go test" })
  vim.keymap.set("n", "<leader>gtf", vim.cmd.GoTestFunc)

  vim.keymap.set("n", "<leader>gtq", function()
    popup:unmount()
  end)

  vim.keymap.set("n", "<leader>gts", function()
    vim.notify("save")
  end)
end

M.setup()
