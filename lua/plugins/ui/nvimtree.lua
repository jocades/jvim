return {
  'kyazdani42/nvim-tree.lua',
  cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
  config = function()
    local callback = require('nvim-tree.config').nvim_tree_callback

    -- See :help nvim-tree.OPTION_NAME`
    require('nvim-tree').setup {
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      -- auto_close = true,
      renderer = {
        root_folder_modifier = ':t',
        icons = {
          glyphs = {
            default = '', -- 
            symlink = '',
            folder = {
              arrow_open = '',
              arrow_closed = '',
              default = '',
              open = '',
              empty = '',
              empty_open = '',
              symlink = '',
              symlink_open = '',
            },
            git = {
              unstaged = '', -- modified
              staged = 'S',
              unmerged = '',
              renamed = '➜',
              untracked = 'U',
              deleted = '',
              ignored = '◌',
            },
          },
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = false,
        icons = {
          hint = 'H', -- '',
          info = 'I', --'',
          warning = 'W', -- '',
          error = 'E', --'',
        },
      },
      view = {
        width = 30,
        side = 'left',
        mappings = {
          list = {
            { key = { 'l', '<CR>', 'o' }, cb = callback 'edit' },
            { key = 'h', cb = callback 'close_node' },
            { key = 'v', cb = callback 'vsplit' },
          },
        },
      },
    }
  end,
}
