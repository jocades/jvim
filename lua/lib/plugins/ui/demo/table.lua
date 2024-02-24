local NuiTable = require('nui.table')
local Text = require('nui.text')

local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event

local popup = Popup({
  enter = true,
  focusable = true,
  border = {
    style = 'rounded',
  },
  position = '50%',
  size = {
    width = '80%',
    height = '60%',
  },
})

-- mount/open the component
popup:mount()

-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function() popup:unmount() end)

popup:map('n', 'q', function() popup:unmount() end)

local tbl = NuiTable({
  ns_id = 'nui_table_ns',
  bufnr = popup.bufnr,
  columns = {
    {
      align = 'center',
      header = 'Name',
      columns = {
        { accessor_key = 'firstName', header = 'First' },
        {
          id = 'lastName',
          accessor_fn = function(row) return row.lastName end,
          header = 'Last',
        },
      },
    },
    {
      align = 'right',
      accessor_key = 'age',
      cell = function(cell)
        return Text(tostring(cell.get_value()), 'DiagnosticInfo')
      end,
      header = 'Age',
    },
  },
  data = {
    { firstName = 'John', lastName = 'Doe', age = 42 },
    { firstName = 'Jane', lastName = 'Doe', age = 27 },
  },
})

tbl:render()
