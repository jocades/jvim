return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      dapui.setup()
      require('nvim-dap-virtual-text').setup({})

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = '/Users/j0rdi/.local/share/nvim/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.c = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input({
              prompt = 'Path to executable: ',
              default = vim.fn.getcwd() .. '/',
              completion = 'file',
            })
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.cpp = dap.configurations.c

      local keymaps = {
        ['<leader>b'] = { dap.toggle_breakpoint, 'Toggle breakpoint' },
        ['<leader>i'] = { dap.step_into, 'Step into' },
        ['<leader>o'] = { dap.step_over, 'Step over' },
        ['<leader>O'] = { dap.step_out, 'Step out' },
        ['<leader>t'] = { dap.terminate, 'Terminate' },
        ['<leader>c'] = { dap.continue, 'Continue' },
        ['<leader>r'] = { dap.repl.open, 'Open REPL' },
        ['<leader>l'] = { dap.run_last, 'Run last' },
      }

      for k, v in pairs(keymaps) do
        require('utils').map('n', k, v[1], { desc = 'DBG: ' .. v[2] })
      end

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },
}
