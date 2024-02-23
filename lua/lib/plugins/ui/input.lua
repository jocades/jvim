local BaseInput = require('nui.input')
local event = require('nui.utils.autocmd').event

---@param props? { title?: string, on_submit?: fun(value: string) }
local function Input(props)
  props = props or {}

  return BaseInput({
    position = '50%',
    size = {
      width = 20,
    },
    border = {
      style = 'single',
      text = {
        -- top = '[Howdy?]',
        top = props.title or '[Howdy?]',
        top_align = 'center',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:Normal',
    },
  }, {
    prompt = '> ',
    on_close = function() print('Input Closed!') end,
    on_submit = props.on_submit or function(value) print('Input Submitted: ' .. value) end,
  })
end

return Input
