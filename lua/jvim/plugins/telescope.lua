return {
  {
    'nvim-telescope/telescope.nvim',
    version = false,
    cmd = 'Telescope',
    dependencies = {
      { -- Telescope fzf native
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = vim.fn.executable('make') == 1,
      },
      -- 'nvim-telescope/telescope-smart-history.nvim',
      -- 'kkharji/sqlite.lua',
    },
    config = function()
      local actions = require('telescope.actions')
      local telescope = require('telescope')
      local trouble = require('trouble.sources.telescope')
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-n>'] = actions.cycle_history_next,
              ['<C-p>'] = actions.cycle_history_prev,
              ['<C-l>'] = trouble.open,
            },
            n = {
              ['q'] = actions.close,
            },
          },
          prompt_prefix = ' ',
          selection_caret = ' ',
          path_display = { 'smart' }, -- truncate, shorten, absolute, tail, smart
          file_ignore_patterns = { '.git/', 'node_modules' },
          layout_strategy = 'horizontal',
          layout_config = {
            prompt_position = 'top',
          },
          selection_strategy = 'reset',
          sorting_strategy = 'ascending',
          scroll_strategy = 'cycle',
          color_devicons = true,
        },
        extensions = {
          fzf = {},
        },
      })
      pcall(telescope.load_extension, 'fzf')

      local b = require('telescope.builtin')
      JVim.register({
        -- Fuzzy find
        { '<C-p>', b.find_files, 'Find files' },
        -- { '<leader>fg', b.git_files, 'Find git files' },
        { '<leader>fg', b.live_grep, 'Find grep' },
        { '<leader>fw', b.grep_string, 'Find current word' },
        { '<leader>/', b.buffers, 'Find existing buffers' },
        {
          '<leader>fl',
          function()
            b.find_files({ ---@diagnostic disable-next-line: param-type-mismatch
              cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy'),
            })
          end,
          'Find lazy plugins',
        },
        {
          '<leader>fp',
          function()
            b.find_files({ cwd = '~/dev/neovim/plugins' })
          end,
          'Find plugins',
        },
        {
          '<leader>fc',
          function()
            b.find_files({ cwd = vim.fn.stdpath('config') })
          end,
          'Find config',
        },
        { '<leader>?', b.oldfiles, 'Find recently opened files' },
        --stylua: ignore
        { '<leader>.', b.current_buffer_fuzzy_find, 'Fuzzily search in current buffer', },
        { '<leader>:', b.command_history, 'Command history' },
        { '<leader>fm', b.man_pages, 'Find man pages' },
        { '<leader>fk', b.keymaps, 'Find keymaps' },
        -- Git
        { '<leader>ch', b.git_commits, 'Git commit history' },
        { '<leader>gs', b.git_status, 'Git status' },
        { '<leader>gb', b.git_branches, 'Git branches' },
        -- { '<leader>gs', b.git_stash, 'Git stash' },
        -- Misc
        { '<leader>fh', b.help_tags, 'Find Help' },
        { '<leader>ts', b.builtin, 'Open Telescope Menu' },
      })
    end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    opts = {
      menu = {
        -- width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>H',
          function()
            require('harpoon'):list():add()
          end,
          desc = 'Harpoon File',
        },
        {
          '<leader>h',
          function()
            local harpoon = require('harpoon')
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick Menu',
        },
        {
          '<C-]>',
          function()
            require('harpoon'):list():next()
          end,
          desc = 'Harpoon File',
        },
        {
          '<C-[>',
          function()
            require('harpoon'):list():prev()
          end,
          desc = 'Harpoon File',
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end
      return keys
    end,
  },
}
