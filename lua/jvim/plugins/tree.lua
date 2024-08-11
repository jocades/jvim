return {
  { -- File explorer
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    keys = {
      {
        '<leader>e',
        function()
          require('neo-tree.command').execute({
            position = 'current',
            toggle = true,
            reveal = true,
          })
        end,
        desc = 'Explorer',
      },

      {
        '<C-n>',
        function()
          require('neo-tree.command').execute({ toggle = true, reveal = true })
        end,
        desc = 'Explorer panel',
      },
      {
        '<leader>ge',
        function()
          require('neo-tree.command').execute({
            toggle = true,
            source = 'git_status',
          })
        end,
        desc = 'Git explorer',
      },
      {
        '<leader>be',
        function()
          require('neo-tree.command').execute({
            toggle = true,
            source = 'buffers',
          })
        end,
        desc = 'Buffer explorer',
      },
    },
    init = function()
      -- load neo-tree directly when opening a dir
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup(
          'Neotree_start_directory',
          { clear = true }
        ),
        desc = 'Start Neo-tree with directory',
        once = true,
        callback = function()
          if package.loaded['neo-tree'] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == 'directory' then
              require('neo-tree')
            end
          end
        end,
      })
    end,
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
      close_if_last_window = false,
      filesystem = {
        bind_to_cwd = false,
        use_libuv_file_watcher = true, -- auto detect file changes
        always_show = { '.gitignored' },
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
}
