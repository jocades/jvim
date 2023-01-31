local present, telescope = pcall(require, 'telescope')
if not present then
  return
end

local actions = require 'telescope.actions'

-- See `:help telescope` and `:help telescope.setup()`
telescope.setup {
  prompt_prefix = ' ',
  selection_caret = ' ',
  path_display = { 'smart' },
  file_ignore_patterns = { '.git/', 'node_modules' },

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

  -- Misc
  ['<leader>fh'] = { b.help_tags, 'Find Help' },
  ['<leader>fc'] = { b.grep_string, 'Find Current word' },
  ['<leader>ts'] = { b.builtin, 'Open Telescope Menu' },
}

for k, v in pairs(K) do
  require('j0rdi.utils').map('n', k, v[1], { desc = v[2] })
end
