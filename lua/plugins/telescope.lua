-- Fuzzy Finder (files, lsp, etc) + Plenary (common neovim lua utils)
return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = 'Telescope',
    dependencies = {
      { -- Telescope fzf native
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = vim.fn.executable 'make' == 1,
      },
      { -- telescope project picker
        'ahmedkhalf/project.nvim',
        config = function()
          require('project_nvim').setup {
            detection_methods = { 'pattern' },
            patterns = { '.git', 'Makefile', 'package.json' },
          }
        end,
      },
    },
    config = function()
      local actions = require 'telescope.actions'
      -- See `:help telescope` and `:help telescope.setup()`
      local telescope = require 'telescope'
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<Down>'] = actions.cycle_history_next,
              ['<Up>'] = actions.cycle_history_prev,
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
                --[[ if cols > 200 then
            return math.floor(cols * 0.4)
          else
            return math.floor(cols * 0.6)
          end ]]
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
      }
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
      -- See `:help telescope.builtin`
      local b = require 'telescope.builtin'
      -- KEYMAPS
      local K = {
        -- Fuzzy find
        ['<leader>ff'] = { b.find_files, 'Find Files' },
        ['<leader>fw'] = { b.live_grep, 'Find Word by grep' },
        ['<leader>fb'] = { b.buffers, 'Find existing buffers' },
        ['<leader>?'] = { b.oldfiles, 'Find recently opened files' },
        ['<leader>.'] = {
          function() -- pass additional configuration to telescope to change theme, layout, etc.
            b.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
          end,
          'Fuzzily search in current buffer]',
        },
        -- Git
        ['<leader>fg'] = { b.git_files, 'Find Git files' },
        ['<leader>cm'] = { b.git_commits, 'Git commits' },
        ['<leader>st'] = { b.git_status, 'Git status' },
        ['<leader>gb'] = { b.git_branches, 'Git branches' },
        ['<leader>gs'] = { b.git_stash, 'Git stash' },
        -- Misc
        ['<leader>fh'] = { b.help_tags, 'Find Help' },
        ['<leader>fc'] = { b.grep_string, 'Find Current word' },
        ['<leader>ts'] = { b.builtin, 'Open Telescope Menu' },
      }
      for k, v in pairs(K) do
        require('j0rdi.utils').map('n', k, v[1], { desc = v[2] })
      end

      telescope.load_extension 'projects'
      telescope.load_extension 'harpoon'
    end,
  },

  -- Organize buffers
  {
    'ThePrimeagen/harpoon',
    config = function()
      local mark = require 'harpoon.mark'
      local ui = require 'harpoon.ui'

      local K = {
        ['<leader>a'] = { mark.add_file, { desc = 'Add file to harpoon' } },
        ['<M-h>'] = { ui.toggle_quick_menu },
        ['<M-j>'] = { function() ui.nav_file(1) end },
        ['<M-k>'] = { function() ui.nav_file(2) end },
        ['<M-l>'] = { function() ui.nav_file(3) end },
        ['<M-;>'] = { function() ui.nav_file(4) end },
      }

      for k, v in pairs(K) do
        require('j0rdi.utils').map('n', k, v[1], v[2])
      end
    end,
  },
}