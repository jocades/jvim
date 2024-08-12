local M = {}

function M.info(path)
  path = path or vim.uv.cwd()
  if vim.uv.fs_stat(vim.fs.joinpath(path, '.git')) then
    return {
      remote = JVim.exe('git config --get remote.origin.url'),
      branch = JVim.exe('git rev-parse --abbrev-ref HEAD'),
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

  JVim.exe({ 'open', info.remote })
end

return M
