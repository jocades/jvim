local M = {}

---@param str string
---@param separator string
---@return string[]
function M.split(str, separator)
  local sep, chunks = separator or ' ', {}
  local pattern = string.format('([^%s]+)', sep)
  ---@diagnostic disable-next-line: discard-returns
  str:gsub(pattern, function(c) chunks[#chunks + 1] = c end)
  return chunks
end

return M
