local M = {}

--- Split a string into a table of strings
---@param str string
---@param separator? string
---@return string[]
function M.split(str, separator)
  local sep, chunks = separator or ' ', {}
  local pattern = string.format('([^%s]+)', sep)
  ---@diagnostic disable-next-line: discard-returns
  str:gsub(pattern, function(c)
    chunks[#chunks + 1] = c
  end)
  return chunks
end

--- Remove leading and trailing whitespaces
---@param str string
---@return string
function M.trim(str)
  return str:gsub('^%s*(.-)%s*$', '%1')[1]
end

--- Capitalize the first letter of a string
---@param str string
---@return string
function M.capitalize(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

return M
