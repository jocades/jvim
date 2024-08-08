-- Search and replace in multiple files
return {
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

  -- Better diagnostics lists
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
  },

  -- Comments
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
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
  },

  -- Neovim libuv types for lua. Plugin will never be loaded
  { 'Bilal2453/luvit-meta', lazy = true },
  { -- optional completion source for require statements and module annotations
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = 'lazydev',
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
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

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      fast_wrap = {
        map = '<M-e>', -- ALT-e on insert mode
        chars = { '{', '[', '(', '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
        offset = 0, -- Offset from pattern match
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'PmenuSel',
        highlight_grey = 'LineNr',
      },
    },
  },
  --   init = function()
  --     require('cmp').event:on(
  --       'confirm_done',
  --       require('nvim-autopairs.completion.cmp').on_confirm_done({
  --         map_char = { tex = '' },
  --       })
  --     )
  --   end,
  -- },

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    opts = {},
  },

  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    lazy = true,
    config = true,
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
  },
}
