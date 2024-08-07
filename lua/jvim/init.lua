require('jvim.lazy')

local M = {}

---@param opts? JVimOptions
function M.setup(opts)
  require('jvim.config').setup(opts)
end

return M
