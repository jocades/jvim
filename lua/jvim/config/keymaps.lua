return {
  n = {
    -- Buffers
    ['<leader>x'] = { JVim.buf.remove, 'Close buffer' },
    ['<leader>X'] = { vim.cmd.tabc, 'Close tab' },
    ['<leader>y'] = { '<cmd>%y+<cr>', 'Copy buffer' },
    ['<leader>v'] = { 'gg0vG$', 'Select buffer' },
    ['<leader>so'] = { '<cmd>w | so %<cr>', 'Soruce and run lua file' },

    -- Windows
    ['<leader>z'] = { vim.cmd.close, { desc = 'Close window', nowait = true } },
    ['<leader>ss'] = { vim.cmd.vsplit, { desc = 'Vertical split' } },
    ['<leader>sh'] = { vim.cmd.split, { desc = 'Horizontal split' } },
    ['<leader>re'] = { vim.cmd.ZenMode, { desc = 'Toggle Zen mode' } },
    ['<C-S-Up>'] = { '<cmd>resize +2<cr>' },
    ['<C-S-Down>'] = { '<cmd>resize -2<cr>' },
    ['<C-S-Left>'] = { '<cmd>vertical resize -2<cr>' },
    ['<C-S-Right>'] = { '<cmd>vertical resize +2<cr>' },

    -- Centralization
    ['<C-d>'] = { '<C-d>zz' },
    ['<C-u>'] = { '<C-u>zz' },

    -- Git
    ['<leader>gg'] = { vim.cmd.Neogit, 'Git panel' },
    ['<leader>gc'] = { '<cmd>Neogit commit<cr>', 'Git commit' },
    ['<leader>gB'] = { JVim.git.browse, 'Git browse' },
    ['<leader>gD'] = { vim.cmd.DiffviewOpen, 'Git diff (project)' },
    ['<leader>gH'] = { vim.cmd.DiffviewFileHistory, 'Git diff (history)' },

    -- Toggle
    ['<leader>td'] = { JVim.toggle.diagnostics, 'Toggle diagnostics' },
    ['<leader>th'] = { JVim.toggle.inlay_hints, 'Toggle inlay hints' },
    ['<leader>tv'] = { JVim.toggle.virtual_text, 'Toggle virtual text' },
    ['<leader>tf'] = { JVim.toggle.formatting, 'Toggle formatting' },

    -- Messages
    ['<leader>nn'] = { vim.cmd.Noice, 'Noice history' },
    ['<leader>nl'] = { '<cmd>Noice last<cr>', 'Noice last' },
  },

  i = {
    -- Exit insert mode
    ['jk'] = { '<ESC>', { nowait = true } },

    -- Navigate horizontally
    ['<C-h>'] = { '<Left>' },
    ['<C-l>'] = { '<Right>' },
  },

  v = {
    -- Move selected block
    ['J'] = { "<cmd>m '>+1<CR>gv=gv" },
    ['K'] = { "<cmd>m '<-2<CR>gv=gv" },

    -- Stay in indent mode
    ['<'] = { '<gv' },
    ['>'] = { '>gv' },
  },
}
