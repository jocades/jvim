return {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = 'Neotree',
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == 'directory' then
        require('neo-tree')
      end
    end
  end,
  deactivate = function() vim.cmd([[Neotree close]]) end,
  opts = {
    window = {
      position = 'left',
      width = 30,
      mappings = {
        ['<space>'] = 'none',
        ['l'] = 'open',
        ['<cr>'] = 'focus_preview',
      },
    },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = true,
    },
  },
}
