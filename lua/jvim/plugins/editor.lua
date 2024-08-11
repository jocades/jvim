return {
  { -- File explorer
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    keys = {
      {
        '<C-n>',
        function()
          require('neo-tree.command').execute({
            toggle = true,
            dir = vim.uv.cwd(),
          })
        end,
        desc = 'Explorer toggle (cwd)',
        remap = true,
      },
      {
        '<leader>e',
        '<cmd>Neotree<cr>',
        desc = 'Explorer focus',
      },
    },
    init = JVim.tree.init,
    deactivate = function()
      vim.cmd.Neotree('close')
    end,
    opts = {
      window = {
        position = 'left',
        width = 30,
        mappings = {
          ['<space>'] = 'none',
          ['l'] = 'open',
          ['P'] = { 'toggle_preview', config = { use_float = false } },
          ['O'] = {
            function(state)
              JVim.open(state.tree:get_node().path, { system = true })
            end,
            desc = 'Open with system app',
          },
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
              JVim.info('Path copied', { title = 'File system' })
            end,
            desc = 'Copy path to clipboard',
          },
        },
      },
      filesystem = {
        bind_to_cwd = false,
        use_libuv_file_watcher = true, -- auto detect file changes
        follow_current_file = { enabled = true },
      },
      source_selector = {
        winbar = false,
        statusline = false,
      },
      default_component_configs = {
        indent = {
          with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
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

  -- Navigate between vim and tmux panes
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },

  -- Distraction free coding
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      plugins = {
        tmux = { enabled = true },
      },
    },
  },
}
