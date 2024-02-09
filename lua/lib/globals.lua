P = function(v) print(vim.inspect(v)) end

Reload = function(...)
  local modules = { ... }
  for _, module in ipairs(modules) do
    package.loaded[module] = nil
  end
  vim.cmd.source('$MYVIMRC')
  print('Reloaded!')
end

Flex = function()
  local friend_name = vim.fn.input('Who are we flexing on?: ')
  friend_name = friend_name:gsub('^%l', string.upper)
  local msg = string.format(" %s... Jordi's config is on another level! He wrote it in Lua! ", friend_name)
  vim.notify(msg, vim.log.levels.WARN, { title = 'Flex' })
end

---Copy a table
---@param tbl table
table.copy = function(tbl)
  local new = {}
  for k, v in pairs(tbl) do
    new[k] = v
  end
  return new
end

---Deep copy a table
---@param tbl table
table.deepcopy = function(tbl)
  local new = {}
  for k, v in pairs(tbl) do
    if type(v) == 'table' then
      new[k] = table.deepcopy(v)
    else
      new[k] = v
    end
  end
  return new
end

---Inspect a table
---@param tbl table
table.inspect = function(tbl)
  for k, v in pairs(tbl) do
    if type(v) == 'table' then
      table.inspect(v)
    else
      print(k, v)
    end
  end
end
