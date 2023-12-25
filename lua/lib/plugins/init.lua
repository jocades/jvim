require('lib.plugins.autorun').setup({
  commands = {
    lua = { 'luajit' },
    ts = { 'bun', 'run' },
    js = { 'bun', 'run' },
  },
  output = { name = 'output' },
})
