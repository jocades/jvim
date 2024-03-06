local shell = require('utils').shell
local Path = require('lib.path')

local src = Path('~/.config/nvim/lua/lib/plugins/rust/test')
local f = src / 'main.rs'

local function main()
  local command =
    string.format('rustc %s -o %s && ./%s', f, src / f.stem, f.stem)
  print('Command:', command)
  local out = shell(command)
  -- print('Output:', out)
end

main()
