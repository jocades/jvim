return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },

    opts = {
      stages = "static",
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
      vim.notify = require("notify")
    end,
  },

  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    ---@module 'ibl'
    ---@type ibl.config
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
        },
      },
    },
    main = "ibl",
  },

  -- Floating statuslines (winbar alternative)
  {
    "b0o/incline.nvim",
    event = "BufReadPost",
    opts = {
      hide = {
        cursorline = true,
        only_win = true,
      },
    },
  },

  -- Ui components for neovim
  { "MunifTanjim/nui.nvim", lazy = true },

  -- Just icons
  {
    "kyazdani42/nvim-web-devicons",
    lazy = true,
    opts = {
      strict = true,
      override_by_extension = {
        astro = {
          icon = "",
          color = "#EF8547",
          name = "astro",
        },
        es = {
          icon = "󰈸",
          color = "#F7DF1E",
          name = "es",
        },
      },
    },
  },

  -- Colorize colors
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        -- background, foreground, virtualtext
        mode = "foreground",
        tailwind = true,
      },
    },
  },

  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    ---@module 'noice'
    opts = {
      cmdline = {
        enabled = true, -- enables the Noice cmdline UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = {}, -- global options for the cmdline. See section on views
        -- -@type table<string, CmdlineFormat>
        format = {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          cmdline = {
            pattern = "^:",
            icon = "",
            lang = "vim",
            title = "",
          },
          lua = {
            pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
            icon = "",
            lang = "lua",
            title = "",
          },
          search_down = {
            kind = "search",
            pattern = "^/",
            icon = " ",
            lang = "regex",
            title = "",
          },
          search_up = {
            kind = "search",
            pattern = "^%?",
            icon = " ",
            lang = "regex",
            title = "",
          },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash", title = "" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖", title = "" },
          input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
        },
      },
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true, -- enables the Noice messages UI
        view = "notify", -- default view for messages
        view_error = "notify", -- view for errors
        view_warn = "notify", -- view for warnings
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },

      routes = {
        {
          view = "split",
          filter = { event = "msg_show", min_height = 50 },
        },

        {
          view = "mini",
          filter = {
            event = "msg_show",
            kind = "",
            any = {
              { find = "^%d+ .*lines" },
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "Already at " },
              -- { find = '.*: Pattern not found' },
            },
          },
        },

        -- {
        --   view = "mini",
        --   filter = {
        --     event = "msg_show",
        --     kind = "",
        --   },
        -- },

        {
          view = "mini",
          filter = {
            event = "msg_show",
            kind = "emsg",
            any = {
              { find = "E37: No" },
              { find = "E162: No" },
              { find = "E486: Pa" },
            },
          },
        },

        {
          view = "mini",
          filter = {
            event = "notify",
            kind = "info",
            find = "Neo.tree",
          },
        },
        {
          view = "mini",
          filter = {
            any = {
              { event = "msg_showmode" },
              -- { event = 'msg_show', kind = 'emsg' },
            },
          },
        },
      },

      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        hover = {
          enabled = true,
          silent = true, -- set to true to not show a message if hover is not available
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        --[[ message = {
          -- Messages shown by lsp servers
          enabled = true,
          view = 'cmdline_popup',
          opts = {},
        }, ]]
      },

      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },
}
