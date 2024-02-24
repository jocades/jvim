local BaseMenu = require('nui.menu')
local event = require('nui.utils.autocmd').event

---@generic T
---@param props { title?: string, items: { text: string, data?: T }[], on_submit?: fun(item: { text: string }) }
local function Menu(props)
  props = props or {}

  return BaseMenu({
    position = '50%',
    size = {
      width = 40,
      height = 10,
    },
    border = {
      style = 'single',
      text = {
        top = props.title or '[Choose-an-Element]',
        top_align = 'center',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:Normal',
    },
  }, {
    lines = table.map(
      props.items or {},
      function(item) return BaseMenu.item(item.text, item.data or {}) end
    ),
    max_width = 20,
    keymap = {
      focus_next = { 'j', '<Down>', '<Tab>' },
      focus_prev = { 'k', '<Up>', '<S-Tab>' },
      close = { '<Esc>', '<C-c>' },
      submit = { '<CR>', '<Space>' },
    },
    on_close = function() print('Menu Closed!') end,
    on_submit = props.on_submit
      or function(item) print('Menu Submitted: ', item.text) end,
  })
end

return Menu
