return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            position = "current",
            toggle = true,
            reveal = true,
            width = "100%",
          })
        end,
        desc = "Explorer",
      },
      --[[ {
        '<C-n>',
        function()
          require('neo-tree.command').execute({ toggle = true })
        end,
        desc = 'Explorer panel',
      }, ]]
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            source = "git_status",
          })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            source = "buffers",
          })
        end,
        desc = "Buffer explorer",
      },
    },

    init = function()
      -- load neo-tree directly when opening a dir
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup(
          "Neotree_start_directory",
          { clear = true }
        ),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,

    deactivate = function()
      vim.cmd.Neotree("close")
    end,

    opts = {
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["P"] = { "toggle_preview", config = { use_float = false } },
          ["O"] = {
            function(state)
              JVim.open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with system app",
          },
          ["E"] = {
            function(state)
              local path = state.tree:get_node().path
              vim.api.nvim_input(": " .. path .. "<Home>")
            end,
            desc = "Execute file",
          },
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
              JVim.info("Path copied", { title = "File system" })
            end,
            desc = "Copy path to clipboard",
          },
        },
      },

      event_handlers = {
        { -- Remove the buffer from the jumplist when using full window.
          event = "file_open_requested",
          handler = function(data)
            if data.state.current_position == "current" then
              require("neo-tree.command").execute({ action = "close" })
            end
          end,
        },
        {
          event = "file_renamed",
          handler = function(data)
            JVim.lsp.request_rename(data.source, data.destination)
          end,
        },
        {
          event = "file_moved",
          handler = function(data)
            JVim.lsp.request_rename(data.source, data.destination)
          end,
        },
      },
      close_if_last_window = true,
      filesystem = {
        bind_to_cwd = false,
        use_libuv_file_watcher = true,
        filtered_items = {
          always_show = { ".gitignore", ".cargo" },
        },
      },
      source_selector = {
        winbar = false,
        statusline = false,
      },
      open_files_do_not_replace_types = {
        "terminal",
        "Trouble",
        "trouble",
        "qf",
        "Outline",
      },
      git_status = {
        symbols = {
          -- Change type
          added = "✚",
          deleted = "✖",
          modified = "",
          renamed = "󰁕",
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },
  },
}
