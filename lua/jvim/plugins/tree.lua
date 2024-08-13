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
          require('neo-tree.command').execute({ toggle = true })
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
              -- vim.ui.open(state.tree:get_node().path())
            end,
            desc = 'Open with system app',
          },
          ['E'] = {
            function(state)
              local path = state.tree:get_node().path
              vim.api.nvim_input(': ' .. path .. '<Home>')
            end,
            desc = 'Execute file',
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
      event_handlers = {
        {
          event = 'file_renamed',
          handler = function(data)
            JVim.lsp.on_rename(data.source, data.destination)
          end,
        },
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
      close_if_last_window = true,
      filesystem = {
        bind_to_cwd = false,
        use_libuv_file_watcher = true,
        filtered_items = {
          always_show = { '.gitignore' },
        },
        --[[ components = {
          harpoon = function(config, node, _)
            local harpoon_list = require('harpoon'):list()
            local path = node:get_id()
            local harpoon_key = vim.uv.cwd()

            for i, item in ipairs(harpoon_list.items) do
              local value = item.value
              if string.sub(item.value, 1, 1) ~= '/' then
                value = harpoon_key .. '/' .. item.value
              end

              if value == path then
                return {
                  text = string.format(' ⥤ %d', i), -- <-- Add your favorite harpoon like arrow here
                  highlight = config.highlight or 'NeoTreeDirectoryIcon',
                }
              end
            end
            return {}
          end,
        }, ]]
        --[[ renderers = {
          file = {
            { 'icon' },
            { 'name', use_git_status_colors = true },
            { 'harpoon' }, --> This is what actually adds the component in where you want it
            { 'diagnostics' },
            { 'git_status', highlight = 'NeoTreeDimText' },
          },
        }, ]]
      },
      source_selector = {
        winbar = false,
        statusline = false,
      },
      open_files_do_not_replace_types = {
        'terminal',
        'Trouble',
        'trouble',
        'qf',
        'Outline',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '✚',
          deleted = '✖',
          modified = '',
          renamed = '󰁕',
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '', --'󰄱',
          staged = '',
          conflict = '',
        },
      },
    },
  },
}
