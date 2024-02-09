require('lib.plugins.autorun').setup({
  commands = {
    lua = { 'luajit' },
    ts = { 'bun', 'run' },
    js = function(file) return { 'node', file.abs } end,
  },
  output = { name = 'output' },
  header = { date = false },
})

require('lib.plugins.next').setup()
