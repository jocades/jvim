local M = {}

---@class KeymapRegister
---@field matching_keymaps Keymap[]
---@field new_keymaps table<string, (function | string)[]>
---@field bufs number[]
local KeymapRegister = {}
KeymapRegister.__index = KeymapRegister

function KeymapRegister.new()
  local self = setmetatable({}, KeymapRegister)
  self.matching_keymaps = {}
  self.new_keymaps = nil
  self.bufs = nil
  return self
end

---@private
function KeymapRegister:extract_matching_keymaps(buf)
  local buf_keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')

  for _, keymap in ipairs(buf_keymaps) do
    if self.new_keymaps[keymap.lhs] then
      table.insert(self.matching_keymaps, keymap)
      vim.keymap.del('n', keymap.lhs, { buffer = buf })
    end
  end
end

---@param new_keymaps table<string, (function | string)[]>
---@param desc_prefix? string
function KeymapRegister:save(new_keymaps, desc_prefix)
  self.new_keymaps = new_keymaps
  self.bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(self.bufs) do
    self:extract_matching_keymaps(buf)

    for k, v in pairs(new_keymaps) do
      vim.keymap.set('n', k, v[1], {
        silent = true,
        buffer = buf,
        desc = string.format('%s%s', desc_prefix or '', v[2]),
      })
    end
  end
end

function KeymapRegister:restore()
  if not self.new_keymaps then
    require('utils.log').error(
      'KeymapRegister:restore() called without calling KeymapRegister:save() first.'
    )
    return
  end

  for _, buf in ipairs(self.bufs) do
    for k, _ in pairs(self.new_keymaps) do
      vim.keymap.del('n', k, { buffer = buf })
    end
  end

  for _, keymap in pairs(self.matching_keymaps) do
    vim.keymap.set('n', keymap.lhs, keymap.callback or keymap.rhs, {
      buffer = keymap.buffer,
      desc = keymap.desc,
      silent = keymap.silent == 1,
      nowait = keymap.nowait == 1,
      noremap = keymap.noremap == 1,
    })
  end

  self.matching_keymaps = {}
  self.new_keymaps = nil
  self.bufs = nil
end

function KeymapRegister:dbg()
  print('== restore keymaps ==')
  P(self.matching_keymaps)
  print('== new keymaps ==')
  P(self.new_keymaps)
end

-- test
-- local kr = KeymapRegister.new()
-- kr:save({ ['i'] = { function() print('hello') end, 'test' } }, 'TEST: ')
-- kr:dbg()
--
-- kr:restore()
-- kr:dbg()

M.KeymapRegister = KeymapRegister

return M
