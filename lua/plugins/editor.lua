return {
  { -- File explorer
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    deactivate = function() vim.cmd([[Neotree close]]) end,
    opts = {
      window = {
        position = 'left',
        width = 30,
        mappings = {
          ['<space>'] = 'none',
          ['l'] = 'open',
          ['<cr>'] = 'focus_preview',
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
        window = {
          mappings = {
            ['gd'] = function(state)
              -- Copy of `open` command from author
              require('neo-tree.sources.common.commands').open(
                state,
                require('neo-tree.utils').wrap(require('neo-tree.sources.filesystem').toggle_directory, state)
              )

              vim.cmd('Gvdiffsplit')
            end,
          },
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added = '✚',
            deleted = '✖',
            modified = '',
            renamed = '',
            -- Status type
            untracked = '',
            ignored = '',
            unstaged = '',
            staged = '',
            conflict = '',
          },
        },
      },
      event_handlers = {
        {
          event = 'neo_tree_window_after_open',
          handler = function(args)
            if args.position == 'left' or args.position == 'right' then
              vim.cmd.wincmd('=')
            end
          end,
        },
        {
          event = 'neo_tree_window_after_close',
          handler = function(args)
            if args.position == 'left' or args.position == 'right' then
              vim.cmd.wincmd('=')
            end
          end,
        },
      },
    },
  },

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
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
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
  { 'iamcco/markdown-preview.nvim', build = 'cd app && npm install', cmd = 'MarkdownPreview' },
}
