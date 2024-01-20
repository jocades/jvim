local M = {}

---@param str string
---@param separator? string
---@return string[]
function M.split(str, separator)
  local sep, chunks = separator or ' ', {}
  local pattern = string.format('([^%s]+)', sep)
  ---@diagnostic disable-next-line: discard-returns
  str:gsub(pattern, function(c) chunks[#chunks + 1] = c end)
  return chunks
end

---@param str string
---@return string, integer
function M.trim(str) return str:gsub('^%s*(.-)%s*$', '%1') end

---@param data string[]
---@param separator? string
function M.join(data, separator)
  local sep, str = separator or ' ', ''
  for _, v in ipairs(data) do
    str = str .. v .. sep
  end
  return str:sub(1, #str - 1)
end

---@param str string
---@return string
function M.capitalize(str) return str:sub(1, 1):upper() .. str:sub(2) end

return M
