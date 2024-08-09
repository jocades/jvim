local ls = require('luasnip')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local input = require('jvim.lib.snippets.helper').input

print('Loaded rust snippets')

local unit_tests = s({
  trig = 'test',
  name = 'unit-tests',
}, {
  t({
    '#[cfg(test)]',
    'mod tests {',
    '\tuse super::*;',
    '',
    '\t#[test]',
    '\tfn ',
  }),
  i(1, 'test_name'),
  t({ '() {', '' }),
  i(0),
  t({
    '\t\tassert_eq!(1, 1);',
    '\t}',
    '}',
  }),
})

ls.add_snippets('rust', {
  unit_tests,
})
