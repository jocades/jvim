local dic = { a = 1, b = 2 }

local ls = { 1, 2, 3 }

for k, v in pairs(dic) do
  print(k, v)
end

for i, v in ipairs(ls) do
  print(i, v)
end
