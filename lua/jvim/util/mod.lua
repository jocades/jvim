local M = {}

---@param modname string
function M.create_requirer(modname)
  return setmetatable({}, {
    __index = function(_, k)
      local ok, mod = pcall(require, modname)
      if not ok then
        JVim.error('No module found ' .. modname)
        return
      end
      if mod[k] then
        return mod[k]
      end
      JVim.error(string.format('No method %s found in %s', k, modname))
    end,
  })
end

return M
