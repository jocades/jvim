local present, telescope = pcall(require, 'telescope')

if not present then
  return
end

local map = function(mode, keys, command, opts)
  vim.keymap.set(mode, keys, command, opts)
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
        ['<Down>'] = actions.cycle_history_next,
        ['<Up>'] = actions.cycle_history_prev,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
local b = require 'telescope.builtin'

-- Fuzzy find
map('n', '<leader>?', b.oldfiles, { desc = '[?] Find recently opened files' })
map('n', '<leader><space>', b.buffers, { desc = 'Find existing buffers' })
map('n', '<leader>ff', b.find_files, { desc = 'Find Files' })
map('n', '<leader>fw', b.live_grep, { desc = 'Find Word by grep' })
map('n', '<leader>/', function() -- pass additional configuration to telescope to change theme, layout, etc.
  b.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

-- Git
map('n', '<leader>fg', b.git_files, { desc = 'Find Git files' })
map('n', '<leader>cm', b.git_commits, { desc = 'Git commits' })
map('n', '<leader>st', b.git_status, { desc = 'Git status' })

-- Misc
map('n', '<leader>fh', b.help_tags, { desc = 'Find Help' })
map('n', '<leader>fc', b.grep_string, { desc = 'Find Current word' })
map('n', '<leader>fd', b.diagnostics, { desc = 'Find Diagnostics' })
