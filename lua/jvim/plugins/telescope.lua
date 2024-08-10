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
              -- Set results loclist with trouble
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
            -- width = 0.95,
            -- height = 0.85,
            -- preview_cutoff = 120,
            prompt_position = 'top',
            -- horizontal = {
            --   preview_width = function(_, cols, _)
            --     return math.floor(cols * 0.6)
            --   end,
            -- },
            -- vertical = {
            --   width = 0.9,
            --   height = 0.95,
            --   preview_height = 0.5,
            -- },
            -- flex = {
            --   horizontal = {
            --     preview_width = 0.9,
            --   },
            -- },
          },
          selection_strategy = 'reset',
          sorting_strategy = 'ascending',
          scroll_strategy = 'cycle',
          color_devicons = true,
        },
        extensions = {
          fzf = {},
          history = {
            limit = 100,
            path = vim.fs.joinpath(
              vim.fn.stdpath('data') --[[@as string]],
              'telescope_history.sqlite3'
            ),
          },
        },
      })
      pcall(telescope.load_extension, 'fzf')
      -- pcall(require('telescope').load_extension, 'smart_history')
      -- pcall(telescope.load_extension, 'harpoon')

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
        { '<leader>fo', ':Telescope harpoon<cr>', 'Open Harpoon Menu' },
      })
    end,
  },

  -- Organize buffers
  --[[ {
    'ThePrimeagen/harpoon',
    config = function()
      local mark = require('harpoon.mark')
      local ui = require('harpoon.ui')

      JVim.keymap.register({
        ['<leader>a'] = { mark.add_file, { desc = 'Add file to harpoon' } },
        ['<leader>jh'] = { ui.toggle_quick_menu, { desc = 'Toggle Harpoon Menu' }, },
        ['<leader>jj'] = { function() ui.nav_file(1) end, }, ['<leader>jk'] = { function() ui.nav_file(2)
          end,
        },
        ['<leader>jl'] = {
          function()
            ui.nav_file(3)
          end,
        },
        ['<leader>j;'] = {
          function()
            ui.nav_file(4)
          end,
        },
      })
    end,
  }, ]]
}
