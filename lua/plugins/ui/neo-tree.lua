return {
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
}