return {
  {
    'rcarriga/nvim-notify',
    keys = {
      {
        '<leader>un',
        function()
          require('notify').dismiss({ silent = true, pending = true })
        end,
        desc = 'Dismiss All Notifications',
      },
    },

    opts = {
      stages = 'static',
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      vim.notify = require('notify')
    end,
  },

  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPost',
    ---@module 'ibl'
    ---@type ibl.config
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
        },
      },
    },
    main = 'ibl',
  },

  -- Floating statuslines for Neovim, winbar alternative
  { 'b0o/incline.nvim', event = 'BufReadPre', config = true },

  -- Ui components
  { 'MunifTanjim/nui.nvim', lazy = true },

  -- Just icons
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    opts = {
      strict = true,
      override_by_extension = {
        astro = {
          icon = '',
          color = '#EF8547',
          name = 'astro',
        },
        es = {
          icon = '󰈸',
          color = '#F7DF1E',
          name = 'es',
        },
      },
    },
  },

  -- Colorize colors
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      user_default_options = {
        -- background, foreground, virtualtext
        mode = 'foreground',
        tailwind = true,
      },
    },
  },
}
