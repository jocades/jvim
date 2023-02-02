-- Auto pairs and tags ("", </>)
return {
  'windwp/nvim-autopairs',
  event = 'VeryLazy',
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
}
