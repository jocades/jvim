local M = {}

---@param name string
function M.get(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)

  if not plugin then
    return {}
  end

  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param modname string
function M.create_requirer(modname)
  return setmetatable({}, {
    __index = function(_, k)
      local ok, mod = pcall(require, modname)
      if not ok then
        JVim.error("No module found " .. modname)
        return
      end
      if mod[k] then
        return mod[k]
      end
      JVim.error(string.format("No method %s found in %s", k, modname))
    end,
  })
end

return M
