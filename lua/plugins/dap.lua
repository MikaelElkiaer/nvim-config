require("utils.init"):create_keymap_group("<leader>d", "+dap")

return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        vim.notify("Debugging started", vim.log.levels.INFO, { title = "nvim-dap" })
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        vim.notify("Debugging stopped", vim.log.levels.INFO, { title = "nvim-dap" })
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        vim.notify("Debugging exited", vim.log.levels.INFO, { title = "nvim-dap" })
      end

      -- Ensure go adapter is configured when launching dap
      require("dap-go").setup()
    end,
    dependencies = {
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "toggle breakpoint" },
      { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "continue" },
      { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "step into" },
      { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "step over" },
      { "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "step out" },
      { "<leader>dr", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "toggle repl" },
      { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "run last" },
      { "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", desc = "terminate" },
    },
  },
  {
    "igorlfs/nvim-dap-view",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>du", "<cmd>lua require'dap-view'.toggle()<cr>", desc = "toggle dap view" },
    },
    opts = {},
  },
}
