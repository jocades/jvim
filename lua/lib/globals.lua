P = function(v) print(vim.inspect(v)) end

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

---@param tbl table
---@param value unknown
---@return boolean
table.includes = function(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

table.is_empty = function(tbl) return next(tbl) == nil end

---Append the values of a list into another list
---@param list table
---@param other table
table.extend = function(list, other)
  for _, value in ipairs(other) do
    table.insert(list, value)
  end
end

-- Reduce function for lua tables
---@param tbl table
---@param fn function
---@param initial unknown
---@return table<unknown>
table.reduce = function(tbl, fn, initial)
  local acc = initial
  for _, value in ipairs(tbl) do
    acc = fn(acc, value)
  end
  return acc
end

---Map function for lua tables
---@param tbl table
---@param fn function
---@return table<unknown>
table.map = function(tbl, fn)
  local new = {}
  for k, v in pairs(tbl) do
    new[k] = fn(v)
  end
  return new
end

---Filter function for lua tables
---@param tbl table
---@param fn function
---@return table<unknown>
table.filter = function(tbl, fn)
  local new = {}
  for k, v in pairs(tbl) do
    if fn(v) then
      new[k] = v
    end
  end
  return new
end

-- xd
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
