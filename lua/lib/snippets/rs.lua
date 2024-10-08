local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local unit_tests = s({
  trig = "test",
  name = "unit-tests",
}, {
  t({
    "#[cfg(test)]",
    "mod tests {",
    "\tuse super::*;",
    "",
    "\t#[test]",
    "\tfn ",
  }),
  i(1, "test_name"),
  t({ "() {", "" }),
  i(0),
  t({
    "\t\tassert_eq!(1, 1);",
    "\t}",
    "}",
  }),
})

local unit_tests_with_error = s({
  trig = "teste",
  name = "unit-tests-with-error",
}, {
  t({
    "#[cfg(test)]",
    "mod tests {",
    "\tuse super::*;",
    "",
    "\ttype Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;",
    "",
    "\t#[test]",
    "\tfn ",
  }),
  i(1, "test_name"),
  t({ "() {", "" }),
  i(0),
  t({
    "\t\tassert_eq!(1, 1);",
    "\t}",
    "}",
  }),
})

ls.add_snippets("rust", {
  unit_tests,
  unit_tests_with_error,
})
