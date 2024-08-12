return {
  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  -- Better surrounding
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'InsertEnter',
    opts = {},
  },

  -- Search and replace
  {
    'MagicDuck/grug-far.nvim',
    opts = { headerMaxWidth = 80 },
    cmd = 'GrugFar',
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require('grug-far')
          local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
          grug.grug_far({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
          })
        end,
        mode = { 'n', 'v' },
        desc = 'Search and Replace',
      },
    },
  },

  -- Better quickfix and loc lists
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = {
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    },
  },

  -- Comments
  {
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    opts = function()
      return {
        pre_hook = require(
          'ts_context_commentstring.integrations.comment_nvim'
        ).create_pre_hook(),
        opleader = {
          line = '<leader>cc',
          block = '<leader>cb',
        },
        toggler = {
          line = '<leader>cc',
          block = '<leader>cb',
        },
      }
    end,
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    build = 'make install_jsregexp',
    --stylua: ignore
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
    --stylua: ignore
    keys = {
      {
        '<c-n>',
        function() return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>' end,
        expr = true,
        silent = true,
        mode = 'i',
      },
      { '<c-n>', function() require('luasnip').jump(1) end, mode = 's' },
      { '<c-p>', function() require('luasnip').jump(-1) end, mode = { 'i', 's' } },
    },
  },

  -- Todos (loclists and hl)
  {
    'folke/todo-comments.nvim',
    event = 'BufReadPost',
    opts = {},
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    { "<leader>tt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>tT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
  },

  -- Configures LuaLS for editing your Neovim config by lazily updating your workspace libraries.
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        'lazy.nvim',
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
    keys = {
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').prev({ skip_groups = true, jump = true }) ---@diagnostic disable-line
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true }) ---@diagnostic disable-line
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next Trouble/Quickfix Item',
      },
    },
  },

  -- Neovim libuv types for lua. Plugin will never be loaded
  { 'Bilal2453/luvit-meta', lazy = true },
}
