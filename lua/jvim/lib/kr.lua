local M = {}

---@class KeymapRegister
---@field new_keymaps table<string, (function | string)[]>
---@field bufs table<number, { matches: Keymap[] }>
local KeymapRegister = {}
KeymapRegister.__index = KeymapRegister

function KeymapRegister.new()
  local self = setmetatable({}, KeymapRegister)
  self.bufs = {}
  self.new_keymaps = nil
  return self
end

---@param pattern string | string[]
---@param new_keymaps table<string, (function | string)[]>
---@param desc_prefix? string
function KeymapRegister:listen(pattern, new_keymaps, desc_prefix)
  self.new_keymaps = new_keymaps

  self.id = vim.api.nvim_create_autocmd('BufEnter', {
    pattern = pattern,
    callback = function(e)
      if self.bufs[e.buf] then return end

      local buf = e.buf
      local buf_keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')

      self.bufs[buf] = { matches = {} }

      for _, buf_keymap in ipairs(buf_keymaps) do
        if self.new_keymaps[buf_keymap.lhs] then
          table.insert(self.bufs[buf].matches, buf_keymap)
          vim.keymap.del('n', buf_keymap.lhs, { buffer = buf })
        end
      end

      for k, v in pairs(new_keymaps) do
        vim.keymap.set('n', k, v[1], {
          silent = true,
          buffer = buf,
          desc = string.format('%s%s', desc_prefix or '', v[2]),
        })
      end
    end,
  })
end

function KeymapRegister:restore()
  vim.api.nvim_del_autocmd(self.id)

  if not self.new_keymaps then
    require('jvim.utils.log').error('No keymaps to restore')
    return
  end

  for buf, keymaps in pairs(self.bufs) do
    for k, _ in pairs(self.new_keymaps) do
      vim.keymap.del('n', k, { buffer = buf })
    end

    for _, keymap in pairs(keymaps.matches) do
      vim.keymap.set('n', keymap.lhs, keymap.callback or keymap.rhs, {
        buffer = keymap.buffer,
        desc = keymap.desc,
        silent = keymap.silent == 1,
        nowait = keymap.nowait == 1,
        noremap = keymap.noremap == 1,
      })
    end
  end

  self.bufs = {}
  self.new_keymaps = nil
  self.id = nil
end

function KeymapRegister:dbg()
  print('== bufs ==')
  P(self.bufs)
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

--[[ vim.g.__debugging = false

local buf_enter_count = 0

local leader = vim.g.mapleader

local new_keymaps = {
  ['K'] = { function() print('hijacked K') end, 'test' },
  -- [leader .. 'fh'] = function() print("hijacked leader 'fh'") end,
  ['i'] = { function() print('hello') end, 'test' },
} ]]

--[[ local kr = KeymapRegister.new() ]]

--[[ map('n', '<leader>gt', function()
  vim.g.__debugging = not vim.g.__debugging
  print('__debugging', vim.g.__debugging)

  if vim.g.__debugging then
    kr:listen('*.lua', new_keymaps, 'TEST: ')
  else
    kr:restore()
  end
end) ]]

return M
