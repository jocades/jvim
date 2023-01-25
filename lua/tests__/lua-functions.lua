local log = function(text)
  print(text .. "!")
end

log "hello"

local function what_about_tables(table)
  print(table.key_one > 5)
end

what_about_tables { key_one = 7 }

local M = {}

M.i = {
  ["jk"] = { "<ESC>", { nowait = true } },
}

M.n = {
  ["cmd"] = { "xxx" },
}

for mode, keymap in pairs(M) do
  for new, op in pairs(keymap) do
    print(mode, new, op[1])
  end
end
