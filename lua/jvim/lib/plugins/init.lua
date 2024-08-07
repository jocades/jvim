require('jvim.lib.plugins.autorun').setup({
    commands = {
        lua = { 'luajit' },
        ts = { 'bun', 'run' },
        js = function(file) return { 'node', file.abs } end,
        py = { 'python' },
        go = { 'go', 'run' },
    },
    header = {
        command = true,
        date = false,
        execution_time = true,
    },
})


-- require('jvim.lib.plugins.notes').setup({
--   data_path = '~/.local/data/notes',
-- })

-- require('jvim.lib.plugins.typo').setup({
--   trigger = '<leader>ft',
-- })

-- require('jvim.lib.plugins.todo').setup()
