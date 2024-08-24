local M = {}

M.in_repo = nil

---@param path? string
function M.is_repo(path)
  -- local paths = vim.fs.find('.git', { type = 'directory', upward = true })
  path = path or vim.uv.cwd()
  return vim.uv.fs_stat(vim.fs.joinpath(path, '.git'))
end

function M.setup()
  M.in_repo = M.is_repo()

  JVim.autocmd('DirChanged', {
    pattern = 'global',
    callback = function()
      M.in_repo = M.is_repo()
    end,
  })
end

---@param path? string
function M.info(path)
  path = path or vim.uv.cwd()
  if M.is_repo(path) then
    return {
      remote = JVim.exe('git config --get remote.origin.url'),
      branch = JVim.exe('git rev-parse --abbrev-ref HEAD'),
    }
  end
  JVim.warn('No git repo found in ' .. path)
end

function M.browse()
  local info = M.info()
  if not info then
    return
  end

  JVim.info({
    'Remote: ' .. info.remote,
    'Branch: ' .. info.branch,
  }, { title = 'Got' })

  JVim.exe({ 'open', info.remote })
end

function M.diff()
  local ft = vim.bo.ft
  local root = vim.uv.cwd()
  local relpath = vim.api.nvim_buf_get_name(0):sub(#root + 2)
  local filename = vim.fs.basename(relpath)
  local cmd = ('git show HEAD:%s'):format(relpath)

  local ok, out = pcall(JVim.exe, cmd)
  if not ok then
    JVim.error(
      'Failed to get previous version. Is this file in a Git repo and committed?',
      { title = 'Git' }
    )
    return
  end

  local prev = vim.split(out, '\n')
  local curr = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))

  local prev_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[prev_buf].ft = ft
  vim.api.nvim_buf_set_lines(prev_buf, 0, -1, false, prev)
  vim.api.nvim_buf_set_name(prev_buf, '[diff] -' .. filename)

  local curr_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[curr_buf].ft = ft
  vim.api.nvim_buf_set_lines(curr_buf, 0, -1, false, curr)
  vim.api.nvim_buf_set_name(curr_buf, '[diff] +' .. filename)

  vim.cmd.tabnew()
  vim.api.nvim_set_current_buf(prev_buf)
  vim.cmd.diffthis()
  vim.cmd.vsplit()
  vim.api.nvim_set_current_buf(curr_buf)
  vim.cmd.diffthis()

  vim.api.nvim_win_set_cursor(0, { line, col })

  vim.keymap.set('n', 'q', vim.cmd.tabc, { buffer = prev_buf })
  vim.keymap.set('n', 'q', vim.cmd.tabc, { buffer = curr_buf })
end

return M
