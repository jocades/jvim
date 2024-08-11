local M = {}

local function exe(cmd)
  if type(cmd) == 'table' then
    cmd = table.concat(cmd, ' ')
  end
  local handle = assert(io.popen(cmd))
  local result = handle:read('*a')
  handle:close()
  return vim.trim(result)
end

function M.info(path)
  path = path or vim.uv.cwd()
  if vim.uv.fs_stat(vim.fs.joinpath(path, '.git')) then
    return {
      remote = exe('git config --get remote.origin.url'),
      branch = exe('git rev-parse --abbrev-ref HEAD'),
    }
  end
  JVim.warn('No git repo found in ' .. path)
end

function M.browse()
  local info = M.info()
  JVim.info({
    'Remote: ' .. info.remote,
    'Branch: ' .. info.branch,
  }, { title = 'Git' })

  exe({ 'open', info.remote })
end

return M
