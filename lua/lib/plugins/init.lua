require('lib.plugins.autorun').setup({
  commands = {
    lua = { 'luajit' },
    ts = { 'bun', 'run' },
    js = function(file) return { 'node' } end,
    go = { 'go', 'run' },
  },
  header = {
    command = true,
    date = false,
    execution_time = true,
  },
})

require('lib.plugins.notes').setup({
  data_path = '~/.local/data/notes',
})

require('lib.plugins.typo').setup({
  trigger = '<leader>ft',
})
