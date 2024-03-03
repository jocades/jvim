# Lua 💜

### Plugins

#### [Autorun](lua/lib/plugins/autorun/init.lua)
Run code with a single command and display the output in a split window.
```lua
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
```

#### [Notes](lua/lib/plugins/notes/init.lua)
Create notes and link between them.
```lua
require('lib.plugins.notes').setup({
  data_path = '~/.local/data/notes',
})
```
