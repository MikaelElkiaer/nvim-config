return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.adapters.netcoredbg = {
        type = 'executable',
        command = '/usr/bin/netcoredbg',
        args = { '--interpreter=vscode' }
      }
      dap.configurations.cs = {
        {
          type = "netcoredbg",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd(), 'file')
          end,
        },
        {
          type = "netcoredbg",
          name = "attach - netcoredbg",
          request = "attach",
          processId = require('dap.utils').pick_process,
        },
      }

      dapui.setup {}

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
    dependencies = { "rcarriga/nvim-dap-ui" },
    init = function()
      require("utils").create_keymap_group("<leader>d", "+dap")
    end,
    keys = {
      { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "toggle breakpoint" },
      { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "continue" },
      { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "step into" },
      { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "step over" },
      { "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "step out" },
      { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "toggle repl" },
      { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "run last" },
      { "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "toggle ui" },
      { "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", desc = "terminate" },
      { "<leader>dk", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "hover" },
    }
  },
}
