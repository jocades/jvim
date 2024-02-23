---@param opts { title?: string, items: string[], on_select: fun(value: string), keymaps: (string | function)[][] } }
local function Picker(opts)
  local actions = require('telescope.actions')
  local actions_state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')
  local dropdown = require('telescope.themes').get_dropdown()

  local function enter(buf)
    local selected = actions_state.get_selected_entry()
    actions.close(buf)
    opts.on_select(selected[1])
  end

  local function next(buf) actions.move_selection_next(buf) end

  local function prev(buf) actions.move_selection_previous(buf) end

  pickers
    .new(dropdown, {
      prompt_title = opts.title or 'Picker',
      finder = finders.new_table(opts.items),
      sorter = sorters.get_generic_fuzzy_sorter({}),
      attach_mappings = function(buf, map)
        map('i', '<CR>', enter)
        map('i', '<C-j>', next)
        map('i', '<C-k>', prev)

        for _, keymap in ipairs(opts.keymaps or {}) do
          local mode, key, action = keymap[1], keymap[2], keymap[3]
          map(mode, key, function()
            actions.close(buf)
            action(buf)
          end)
        end

        return true
      end,
    })
    :find()
end

return Picker
