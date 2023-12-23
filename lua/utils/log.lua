return {
  info = function(msg) vim.notify(msg, vim.log.levels.INFO) end,
  error = function(msg) vim.notify(msg, vim.log.levels.ERROR) end,
  warn = function(msg) vim.notify(msg, vim.log.levels.WARN) end,
  debug = function(msg) vim.notify(msg, vim.log.levels.DEBUG) end,
  trace = function(msg) vim.notify(msg, vim.log.levels.TRACE) end,
}
