local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- mardkwon helpers like ```pyhthon and ```typescript
local function md_code_block(lang)
  return s({
    trig = lang,
    name = "Markdown " .. lang:sub(1, 1):upper() .. lang:sub(2),
  }, {
    t({ "```" .. lang, "" }),
    i(0),
    t({ "", "```" }),
  })
end

ls.add_snippets("markdown", {
  md_code_block("py"),
  md_code_block("ts"),
})
