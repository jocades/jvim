return {
  {
    dir = '~/dev/nvim/plugins/autorun',
    cmd = 'Run',
    config = function() require('autorun').setup() end,
  },
  {
    dir = '~/dev/nvim/plugins/todo-organizer',
    cmd = { 'Todos', 'ScanTodos' },
    config = true,
  },
}
