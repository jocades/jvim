local ok1, npairs = pcall(require, 'nvim-autopairs')
local ok2, auto_tag = pcall(require, 'nvim-ts-autotag') -- React, HTML auto closing tags

if not ok1 then
  return
end

if ok2 then
  auto_tag.setup()
end

npairs.setup {
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

-- Integrate with cmp
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local cmp_present, cmp = pcall(require, 'cmp')
if not cmp_present then
  return
end

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })
