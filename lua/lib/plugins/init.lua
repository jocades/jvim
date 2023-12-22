require('lib.plugins.autorun').setup({
  commands = {
    py = function()
      print('Running python')
      return { 'python' }
    end,
    lua = { 'luajit' },
    ts = { 'bun', 'run' },
    js = { 'bun', 'run' },
  },
})
