return {
  'hrsh7th/nvim-cmp',
  version = false, -- last release is way too old
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- lsp completion
    'hrsh7th/cmp-path', -- path completion
    'hrsh7th/cmp-buffer', -- buffer completion
    -- 'hrsh7th/cmp-cmdline', -- cmdline completion
    'saadparwaiz1/cmp_luasnip', -- snippet completion
    'onsails/lspkind-nvim', -- icons for completion
  },
  opts = function()
    local cmp = require('cmp')
    local lspkind = require('lspkind')

    return {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete({}),
        ['<C-i>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        -- confirm with enter
        -- ['<CR>'] = cmp.mapping.confirm({
        --   behavior = cmp.ConfirmBehavior.Replace,
        --   select = true,
        -- }),
        ['<C-n>'] = cmp.config.disable,
        ['<C-p>'] = cmp.config.disable,
      }),
      formatting = { -- pop-up menu looks
        format = lspkind.cmp_format({
          with_text = true,
          mode = 'symbol_text',
          maxwidth = 50,
          menu = {
            buffer = '[buf]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[api]',
            path = '[path]',
            luasnip = '[snip]',
          },
          -- Tailwind support
          before = function(entry, vim_item)
            if
              vim_item.kind == 'Color' and entry.completion_item.documentation
            then
              local _, _, r, g, b = string.find(
                entry.completion_item.documentation,
                '^rgb%((%d+), (%d+), (%d+)'
              )
              if r then
                local color = string.format('%02x', r)
                  .. string.format('%02x', g)
                  .. string.format('%02x', b)
                local group = 'Tw_' .. color
                if vim.fn.hlID(group) < 1 then
                  vim.api.nvim_set_hl(0, group, { fg = '#' .. color })
                end
                vim_item.kind = '■' -- or "⬤" or anything
                vim_item.kind_hl_group = group
                return vim_item
              end
            end
            -- vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. vim_item.kind) or vim_item.kind
            -- or just show the icon
            vim_item.kind = lspkind.symbolic(vim_item.kind)
                and lspkind.symbolic(vim_item.kind)
              or vim_item.kind
            return vim_item
          end,
        }),
      },
      sources = { -- order matters
        { name = 'nvim_lsp' },
        { name = 'buffer', keyword_length = 5 },
        { name = 'path' },
        { name = 'luasnip' },
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
    }
  end,
}
