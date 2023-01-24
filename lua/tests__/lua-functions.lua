local log = function(text)
  print(text .. "!")
end

log "hello"

local function what_about_tables(table)
  print(table.key_one > 5)
end

what_about_tables { key_one = 7 }
