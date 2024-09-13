local ls = require('luasnip')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local main_fn = s({
  trig = 'main',
  name = 'Python Main Function',
}, {
  t({
    'def main() -> None:',
    '\t',
  }),
  i(0, 'pass'),
  t({
    '',
    '',
    '',
    'if __name__ == "__main__":',
    '\tmain()',
  }),
})

ls.add_snippets('python', {
  main_fn,
})
