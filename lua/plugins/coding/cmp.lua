return {
  -- Auto completion
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- lsp completion
    'hrsh7th/cmp-buffer', -- buffer completion
    'hrsh7th/cmp-cmdline', -- cmdline completion
    'saadparwaiz1/cmp_luasnip', -- snippet completion
    'hrsh7th/cmp-path', -- path completion
    'onsails/lspkind-nvim', -- icons for completion
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'
    cmp.setup {
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-i>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
      },
      formatting = { -- pop-up menu looks
        format = lspkind.cmp_format {
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
        },
      },
      sources = { -- order matters
        { name = 'nvim_lsp' },
        { name = 'nvim-lua' },
        { name = 'luasnip' },
        -- TODO:
        -- {name = 'copilot'},
        { name = 'buffer', keyword_length = 5 },
        { name = 'path' },
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
    }
  end,
}
