require('lib.plugins.autorun').setup({
  commands = {
    lua = { 'luajit' },
    ts = { 'bun', 'run' },
    js = function(file) return { 'node' } end,
    go = { 'go', 'run' },
  },
  -- output = { name = 'output' },
  header = {
    command = true,
    date = false,
    execution_time = true,
  },
})

require('lib.plugins.notes').setup()
