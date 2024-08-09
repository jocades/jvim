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
    },
    config = function()
      local actions = require('telescope.actions')
      local telescope = require('telescope')
      local trouble = require('trouble.providers.telescope')
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
              ['<C-l>'] = trouble.open_with_trouble,
            },
            n = {
              ['q'] = actions.close,
            },
          },
          prompt_prefix = ' ', --  ',
          selection_caret = ' ', --' ',
          path_display = { 'smart' }, -- truncate, shorten, absolute, tail, smart
          file_ignore_patterns = { '.git/', 'node_modules' },
          layout_strategy = 'horizontal',
          layout_config = {
            width = 0.95,
            height = 0.85,
            -- preview_cutoff = 120,
            prompt_position = 'top',
            horizontal = {
              preview_width = function(_, cols, _)
                return math.floor(cols * 0.6)
              end,
            },
            vertical = {
              width = 0.9,
              height = 0.95,
              preview_height = 0.5,
            },
            flex = {
              horizontal = {
                preview_width = 0.9,
              },
            },
          },
          selection_strategy = 'reset',
          sorting_strategy = 'ascending',
          scroll_strategy = 'cycle',
          color_devicons = true,
        },
      })
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'harpoon')

      local b = require('telescope.builtin')
      JVim.register({
        -- Fuzzy find
        { '<C-p>', b.find_files, 'Find Files' },
        { '<leader>fw', b.live_grep, 'Find Word by grep' },
        { '<leader>fc', b.grep_string, 'Find Current word' },
        { '<leader>/', b.buffers, 'Find existing buffers' },
        { '<leader>?', b.oldfiles, 'Find recently opened files' },
        --stylua: ignore
        { '<leader>.', b.current_buffer_fuzzy_find, 'Fuzzily search in current buffer', },
        { '<leader>:', b.command_history, 'Command history' },
        { '<leader>fm', b.marks, 'Find marks' },
        { '<leader>fk', b.keymaps, 'Find keymaps' },
        { '<leader>th', b.colorscheme, 'Switch colorscheme' },
        -- Git
        { '<leader>fg', b.git_files, 'Find Git files' },
        { '<leader>ch', b.git_commits, 'Git commit history' },
        { '<leader>st', b.git_status, 'Git status' },
        { '<leader>gb', b.git_branches, 'Git branches' },
        { '<leader>gs', b.git_stash, 'Git stash' },
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
