return {
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "NeogitOrg/neogit",
    -- Just use lazygit for now...
    enabled = false,
    cmd = "Neogit",
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`

      on_attach = function(buf)
        local gs = package.loaded.gitsigns

        JVim.register({
          {
            "]h",
            function()
              if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
              else
                gs.nav_hunk("next")
              end
            end,
            "Next hunk",
          },
          {
            "[h",
            function()
              if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
              else
                gs.nav_hunk("prev")
              end
            end,
            "Prev hunk",
          },
          { -- Diff current file in new tab
            "<leader>gd",
            function()
              vim.cmd.tabnew(vim.api.nvim_buf_get_name(0))
              gs.diffthis("~")
            end,
            "diff",
          },
          -- { "<leader>gS", gs.stage_buffer, "stage buffer" },
          { "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline" },
          {
            "<leader>ghb",
            function()
              gs.blame_line({ full = true })
            end,
            "Blame Line",
          },
          {
            "<leader>ghB",
            function()
              gs.blame()
            end,
            "Blame Buffer",
          },
        }, function(opts)
          opts.desc = "Git " .. opts.desc
          opts.buffer = buf
        end)
      end,
    },
  },
}
