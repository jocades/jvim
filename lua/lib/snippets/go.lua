local ls = require('luasnip')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local check_error = s({
  trig = 'ie',
  name = 'check error',
}, {
  t({ 'if err != nil {', '\t' }),
  i(0, 'return '),
  t({ 'err', '}' }),
})

ls.add_snippets('go', {
  check_error,
})
