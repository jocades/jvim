return {
  -- Auto completion
  {
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
  },

  -- Auto comment, tsx enabled via context. ("gc" to comment visual regions/lines).
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        opleader = {
          line = '<C-/>',
          block = '<C-/>',
        },
        toggler = {
          line = '<C-/>',
          block = '<leader>cb',
        },
      }
    end,
  },

  -- Auto pairs and tags ("", </>)
  {
    'windwp/nvim-autopairs',
    dependencies = { { 'windwp/nvim-ts-autotag', config = true } },
    config = function()
      require('nvim-autopairs').setup {
        check_ts = true,
        ts_config = {
          lua = { 'string', 'source' },
          javascript = { 'string', 'template_string' },
          java = false,
        },
        disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
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
      }
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp_present, cmp = pcall(require, 'cmp')
      if not cmp_present then
        return
      end
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })
    end,
  },
}
