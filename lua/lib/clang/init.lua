local tmux = require("lib.tmux")
--[[ local fname = vim.fn.fnamemodify(path, ":t")
local stem = vim.fn.fnamemodify(path, ":t:r")
local ext = vim.fn.fnamemodify(path, ":e")
--]]

-- local cpp_hpp = vim.fs.find(function(name, path)
--   return name:match(".*%.[ch]pp$") and path:match("[/\\\\]lib$")
-- end, { limit = math.huge, type = "file" })

local state = {
  buf = nil,
}

local function execute()
  local cmd = { "clang++", "-std=c++20", "-O2", "-flto", "-Wall", "-Wextra" }
  local path = vim.api.nvim_buf_get_name(0)
  local stem = vim.fn.fnamemodify(path, ":t:r")
  table.insert(cmd, "-o")
  table.insert(cmd, stem)
  table.insert(cmd, path)

  table.insert(cmd, "&&")
  table.insert(cmd, "./main")

  -- tmux.run(cmd)

  local out = JVim.exe("tmux list-panes")
  local lines = vim.split(out.stdout, "\n", { trimempty = true })

  if #lines == 1 then
    JVim.exe("tmux split-window -v -l 20%")
  else
    JVim.exe("tmux select-pane -l")
  end

  vim
    .system({ "tmux", "send-keys", table.concat(cmd, " "), "Enter" }, nil)
    :wait()
  vim.system({ "tmux", "select-pane", "-l" })

  -- vim.system(cmd, { text = true }, function(o)
  --   vim.schedule(function()
  --     if state.buf == nil then
  --       state.buf = vim.api.nvim_create_buf(false, true)
  --       vim.bo[state.buf].ft = "sh"
  --       vim.cmd.split()
  --       vim.keymap.set("n", "q", vim.cmd.q, { buffer = state.buf })
  --     end
  --
  --     vim.api.nvim_set_current_buf(state.buf)
  --     local h = vim.api.nvim_win_get_height(0)
  --     vim.api.nvim_win_set_height(0, math.floor(h / 2))
  --
  --     local content = { table.concat(cmd, " "), "" }
  --     JVim.extend(
  --       content,
  --       vim.split(
  --         o.code == 0 and o.stdout or o.stderr,
  --         "\n",
  --         { trimempty = true }
  --       )
  --     )
  --
  --     vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
  --   end)
  -- end)
end

vim.keymap.set("n", "<leader>cp", execute)
