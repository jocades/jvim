return {
  "hrsh7th/nvim-cmp",
  version = false,
  event = "InsertEnter",
  keys = {
    -- See opts.combo from nvim-cmp-lsp-rs below
    {
      "<leader>bc",
      "<cmd>lua require'cmp_lsp_rs'.combo()<cr>",
      desc = "(nvim-cmp) switch comparators",
    },
  },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- lsp completion
    "hrsh7th/cmp-path", -- path completion
    "hrsh7th/cmp-buffer", -- buffer completion
    "saadparwaiz1/cmp_luasnip", -- snippet completion
    "onsails/lspkind-nvim", -- icons for completion
    {
      "zjp-CN/nvim-cmp-lsp-rs",
      ---@type cmp_lsp_rs.Opts
      opts = {
        -- Filter out import items starting with one of these prefixes.
        -- A prefix can be crate name, module name or anything an import
        -- path starts with, no matter it's complete or incomplete.
        -- Only literals are recognized: no regex matching.
        unwanted_prefix = { "color", "ratatui::style::Styled" },
        -- make these kinds prior to others
        -- e.g. make Module kind first, and then Function second,
        --      the rest ordering is merged from a default kind list
        kind = function(k)
          -- The argument in callback is type-aware with opts annotated,
          -- so you can type the CompletionKind easily.
          return { k.Module, k.Function }
        end,
        -- Override the default comparator list provided by this plugin.
        -- Mainly used with key binding to switch between these Comparators.
        combo = {
          -- The key is the name for combination of comparators and used
          -- in notification in swiching.
          -- The value is a list of comparators functions or a function
          -- to generate the list.
          alphabetic_label_but_underscore_last = function()
            local comparators = require("cmp_lsp_rs").comparators
            return { comparators.sort_by_label_but_underscore_last }
          end,
          recentlyUsed_sortText = function()
            local compare = require("cmp").config.compare
            local comparators = require("cmp_lsp_rs").comparators
            -- Mix cmp sorting function with cmp_lsp_rs.
            return {
              compare.recently_used,
              compare.sort_text,
              comparators.sort_by_label_but_underscore_last,
            }
          end,
        },
      },
    },
  },
  opts = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local cmp_lsp_rs = require("cmp_lsp_rs")
    local comparators = cmp_lsp_rs.comparators
    local compare = cmp.config.compare

    local opts = {
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      sorting = {
        comparators = {
          compare.exact,
          compare.score,
          -- comparators.inherent_import_inscope,
          comparators.inscope_inherent_import,
          comparators.sort_by_label_but_underscore_last,
        },
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.config.disable,
        ["<C-p>"] = cmp.config.disable,
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-i>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      }),
      sources = { -- order matters
        { name = "nvim_lsp" },
        { name = "buffer", keyword_length = 4 },
        { name = "path" },
        { name = "luasnip" },
        {
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        },
      },
      formatting = { -- pop-up menu looks
        format = lspkind.cmp_format({
          with_text = true,
          mode = "symbol_text",
          maxwidth = 50,
          menu = {
            buffer = "[buf]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[api]",
            path = "[path]",
            luasnip = "[snip]",
          },
          -- Tailwind support
          before = function(entry, vim_item)
            if
              vim_item.kind == "Color" and entry.completion_item.documentation
            then
              local _, _, r, g, b = string.find(
                entry.completion_item.documentation,
                "^rgb%((%d+), (%d+), (%d+)"
              )
              if r then
                local color = string.format("%02x", r)
                  .. string.format("%02x", g)
                  .. string.format("%02x", b)
                local group = "Tw_" .. color
                if vim.fn.hlID(group) < 1 then
                  vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
                end
                vim_item.kind = "■" -- or "⬤" or anything
                vim_item.kind_hl_group = group
                return vim_item
              end
            end
            vim_item.kind = lspkind.symbolic(vim_item.kind)
                and lspkind.symbolic(vim_item.kind)
              or vim_item.kind
            return vim_item
          end,
        }),
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
    }

    for _, source in ipairs(opts.sources) do
      cmp_lsp_rs.filter_out.entry_filter(source)
    end

    return opts
  end,
}
