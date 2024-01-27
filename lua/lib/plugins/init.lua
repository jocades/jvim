require('lib.plugins.autorun').setup({
  commands = {
    lua = { 'luajit' },
    ts = { 'bun', 'run' },
    js = function(file) return { 'node', file.abs } end,
  },
  output = { name = 'output' },
})

require('lib.plugins.next').setup()
