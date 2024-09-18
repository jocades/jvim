return {
  {
    "mfussenegger/nvim-dap",
    cmd = "Dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- C/C++
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "/Users/j0rdi/.local/share/nvim/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.c = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input({
              prompt = "Path to executable: ",
              default = vim.fn.getcwd() .. "/",
              completion = "file",
            })
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.cpp = dap.configurations.c

      for k, v in pairs({
        ["<leader>dc"] = { dap.continue, "Continue" }, -- use it to start dap
        ["<leader>db"] = { dap.toggle_breakpoint, "Toggle breakpoint" },
      }) do
        require("jvim.util").map("n", k, v[1], { desc = "DAP: " .. v[2] })
      end

      local keymaps = {
        ["i"] = { dap.step_into, "Step into" },
        ["o"] = { dap.step_over, "Step over" },
        ["O"] = { dap.step_out, "Step out" },
        ["<leader>t"] = { dap.terminate, "Terminate" },
        ["<leader>r"] = { dap.repl.open, "Open REPL" },
        ["<leader>l"] = { dap.run_last, "Run last" },
        ["<leader>k"] = {
          function()
            dapui.eval(nil, { enter = true })
          end,
          "Hover",
        },
      }

      local kr = require("lib.kr").KeymapRegister.new()

      dap.listeners.before.event_initialized["me"] = function()
        local ext = vim.fn.expand("%:e")
        kr:listen("*." .. ext, keymaps, "DAP: ")
        print("Keymaps saved")
        kr:dbg()
      end

      dap.listeners.after.event_terminated["me"] = function()
        kr:restore()
        print("Keymaps restored")
        kr:dbg()
      end

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})
    end,
  },
}
