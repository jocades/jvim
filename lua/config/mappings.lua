local cmd = vim.cmd
local new_buf = require('utils').handle_new_buf

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local K = {
  -- NORMAL
  n = {
    -- Common
    ['<C-n>'] = { '<cmd>Neotree toggle<cr>', { desc = 'Toggle nvim-tree' } },
    ['<leader>e'] = { cmd.Neotree, { desc = 'Focus nvim-tree' } },
    ['<leader>q'] = { cmd.qall, { desc = 'Quit all' } },
    ['<leader>Q'] = { '<cmd>qall!<cr>', { desc = 'Quit no save' } },
    ['<leader>la'] = { '<cmd>Lazy<cr>', { desc = 'Open pkg manager' } },

    -- Buffer actions
    ['<leader>x'] = { cmd.Bdelete, { desc = 'Close buffer', nowait = true } },
    ['<leader>X'] = { '<cmd>Bdelete!<cr>', { desc = 'Close buffer without saving' } },
    ['<leader>bd'] = { require('utils').close_saved, { desc = 'Close all saved buffers' } },
    ['<leader>nf'] = { new_buf, { desc = 'Create new file in current dir' } },
    ['<leader>ns'] = { function() new_buf { type = 'v' } end, { desc = 'Create new vertical split' } },
    ['<leader>nh'] = { function() new_buf { type = 'h' } end, { desc = 'Create new horizontal split' } },
    ['<leader>so'] = { '<cmd>w | so %<cr>', { desc = 'Save, source & run current config file' } },
    ['<C-s>'] = { cmd.w, { desc = 'Save buffer' } },
    ['<leader>y'] = { '<cmd>%y+<cr>', { desc = 'Copy whole buffer' } },

    -- Buffer navigation (telescope + harpoon)
    ['L'] = { cmd.bnext },
    ['H'] = { cmd.bprev },

    -- Window actions
    ['<leader>z'] = { cmd.close, { desc = 'Close window', nowait = true } },
    ['<leader>ss'] = { cmd.vsplit, { desc = 'Vertical split' } },
    ['<leader>sh'] = { cmd.split, { desc = 'Horizontal split' } },
    ['<leader>re'] = { cmd.ZenMode, { desc = 'Toggle Zen mode' } },
    ['<C-Up>'] = { '<cmd>resize +2<cr>' },
    ['<C-Down>'] = { '<cmd>resize -2<cr>' },
    ['<C-Left>'] = { '<cmd>vertical resize -2<cr>' },
    ['<C-Right>'] = { '<cmd>vertical resize +2<cr>' },

    -- Window navigation
    ['<C-h>'] = { '<C-w>h' },
    ['<C-l>'] = { '<C-w>l' },
    ['<C-j>'] = { '<C-w>j' },
    ['<C-k>'] = { '<C-w>k' },

    -- Insert blank line
    ['<C-cr>'] = { 'o<ESC>' },
    ['<S-cr>'] = { 'O<ESC>' },

    -- Centralization
    ['<leader>c'] = { 'zz', { nowait = true } },
    ['<C-d>'] = { '<C-d>zz' },
    ['<C-u>'] = { '<C-u>zz' },

    -- Git
    ['<leader>gd'] = { '<cmd>Gvdiffsplit<cr>', { desc = 'Git diff' } },
    ['<leader>lg'] = { '<cmd>lua Lazygit()<cr>', { desc = 'Lazygit' } },
    ['<leader>gp'] = {
      function()
        vim.cmd('!git pull')
        vim.notify('Git pull', vim.log.levels.WARN, { title = 'Git' })
      end,
      { desc = 'Git pull' },
    },
  },

  -- INSERT
  i = {
    -- Exit insert mode
    ['jk'] = { '<ESC>', { nowait = true } },

    -- Navigate horizontally
    ['<C-h>'] = { '<Left>' },
    ['<C-l>'] = { '<Right>' },
  },

  -- VISUAL
  v = {
    -- Move selected block
    ['J'] = { "<cmd>m '>+1<CR>gv=gv" },
    ['K'] = { "<cmd>m '<-2<CR>gv=gv" },

    -- Stay in indent mode
    ['<'] = { '<gv' },
    ['>'] = { '>gv' },
  },
}

for mode, mappings in pairs(K) do
  for k, t in pairs(mappings) do
    require('utils').map(mode, k, t[1], t[2])
  end
end
