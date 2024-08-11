return {
  n = {
    -- Common
    ['<C-n>'] = { '<cmd>Neotree toggle<cr>', { desc = 'Toggle nvim-tree' } },
    ['<leader>e'] = { vim.cmd.Neotree, { desc = 'Focus nvim-tree' } },

    -- Buffer actions
    -- stylua: ignore start
    ['<leader>x'] = { JVim.buf.remove, { desc = 'Close buffer', nowait = true } },
    ['<leader>X'] = { '<cmd>tabc<cr>', 'Close tab' },
    ['<leader>so'] = { '<cmd>w | so %<cr>', { desc = 'Save, source & run current config file' }, },
    ['<leader>y'] = { '<cmd>%y+<cr>', { desc = 'Copy whole buffer' } },
    ['<leader>v'] = { 'gg0vG$', { desc = 'Select whore buffer' } },
    -- stylua: ignore end

    -- Window actions
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
    ['<leader>gg'] = { JVim.git.open, 'Git panel' },
    ['<leader>gc'] = { ':Neogit commit<cr>', 'Git commit' },
    ['<leader>gB'] = { JVim.git.browse, 'Git browse' },
    ['<leader>gd'] = { ':DiffviewFileHistory %<cr>', 'Git diff (buffer)' },
    ['<leader>gD'] = { ':DiffviewOpen<cr>', 'Git diff (project)' },
    ['<leader>gF'] = { ':DiffviewFileHistory<cr>', 'Git diff (history)' },

    -- Toggle
    ['<leader>td'] = { JVim.toggle.diagnostics, 'Toggle diagnostics' },
    ['<leader>th'] = { JVim.toggle.inlay_hints, 'Toggle inlay hints' },
    ['<leader>tv'] = { JVim.toggle.virtual_text, 'Toggle virtual text' },
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
