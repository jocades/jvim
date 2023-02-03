return {
  { -- Terminal
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    config = function()
      require('toggleterm').setup {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
        },
      }
      function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end
      vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
      local Terminal = require('toggleterm.terminal').Terminal
      -- Global functions can be executed from anywhere e.g `:lua Python()`
      local python = Terminal:new { cmd = 'python', hidden = true }
      function Python() python:toggle() end
      local node = Terminal:new { cmd = 'node', hidden = true }
      function Node() node:toggle() end
      local lua = Terminal:new { cmd = 'lua', hidden = true }
      function Lua() lua:toggle() end
      local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }
      function Lazygit() lazygit:toggle() end
    end,
  },

  -- Distraction free coding
  { 'folke/zen-mode.nvim', cmd = 'ZenMode', config = true },

  -- Markdown preview
  { 'iamcco/markdown-preview.nvim', build = 'cd app && yarn install', cmd = 'MarkdownPreview' },
}
