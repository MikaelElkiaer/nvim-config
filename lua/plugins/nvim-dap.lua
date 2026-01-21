require("utils.init"):create_keymap_group("<leader>d", "+dap")

local function init(has_dapview)
  vim.keymap.set("n", "<LocalLeader>b", ":lua require('dap').toggle_breakpoint()<CR>", { desc = "toggle breakpoint" })
  vim.keymap.set("n", "<LocalLeader>c", ":lua require('dap').continue()<CR>", { desc = "continue" })
  vim.keymap.set("n", "<LocalLeader>g", ":lua require('dap').goto_()<CR>", { desc = "go to" })
  vim.keymap.set("n", "<LocalLeader>k", ":lua require('dap').step_back()<CR>", { desc = "step back" })
  vim.keymap.set("n", "<LocalLeader>l", ":lua require('dap').step_into()<CR>", { desc = "step into" })
  vim.keymap.set("n", "<LocalLeader>j", ":lua require('dap').step_over()<CR>", { desc = "step over" })
  vim.keymap.set("n", "<LocalLeader>h", ":lua require('dap').step_out()<CR>", { desc = "step out" })
  vim.keymap.set("n", "<LocalLeader>r", ":lua require('dap').run_to_cursor()<CR>", { desc = "run to cursor" })
  vim.keymap.set("n", "<LocalLeader>s", ":lua require('dap').status()<CR>", { desc = "status" })
  vim.keymap.set("n", "<LocalLeader>t", ":lua require('dap').terminate()<CR>", { desc = "terminate" })

  if has_dapview then
    -- stylua: ignore start
    vim.keymap.set("n", "<LocalLeader>B", ":lua require('dap-view').show_view('breakpoints')<CR>", { desc = "show breakpoints" })
    vim.keymap.set("n", "<LocalLeader>E", ":lua require('dap-view').show_view('exceptions')<CR>", { desc = "show exceptions" })
    vim.keymap.set("n", "<LocalLeader>R", ":lua require('dap-view').show_view('repl')<CR>", { desc = "show repl" })
    vim.keymap.set("n", "<LocalLeader>S", ":lua require('dap-view').show_view('scopes')<CR>", { desc = "show scopes" })
    vim.keymap.set("n", "<LocalLeader>T", ":lua require('dap-view').show_view('threads')<CR>", { desc = "show threads" })
    vim.keymap.set("n", "<LocalLeader>W", ":lua require('dap-view').show_view('watches')<CR>", { desc = "show watches" })
    -- stylua: ignore end
  end
end

local function close(has_dapview)
  vim.keymap.del("n", "<LocalLeader>b")
  vim.keymap.del("n", "<LocalLeader>c")
  vim.keymap.del("n", "<LocalLeader>g")
  vim.keymap.del("n", "<LocalLeader>k")
  vim.keymap.del("n", "<LocalLeader>l")
  vim.keymap.del("n", "<LocalLeader>j")
  vim.keymap.del("n", "<LocalLeader>h")
  vim.keymap.del("n", "<LocalLeader>r")
  vim.keymap.del("n", "<LocalLeader>s")
  vim.keymap.del("n", "<LocalLeader>t")

  if has_dapview then
    vim.keymap.del("n", "<LocalLeader>B")
    vim.keymap.del("n", "<LocalLeader>E")
    vim.keymap.del("n", "<LocalLeader>R")
    vim.keymap.del("n", "<LocalLeader>S")
    vim.keymap.del("n", "<LocalLeader>T")
    vim.keymap.del("n", "<LocalLeader>W")
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local has_dapview, dapview = pcall(require, "dap-view")

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

      dap.listeners.after.event_initialized["config"] = function()
        vim.notify("Debugging started", vim.log.levels.INFO, { title = "nvim-dap" })
        init(has_dapview)
        if has_dapview then
          dapview.open()
        end
      end

      dap.listeners.before.event_terminated["config"] = function()
        vim.notify("Debugging stopped", vim.log.levels.INFO, { title = "nvim-dap" })
        if has_dapview then
          dapview.close()
        end
        close(has_dapview)
      end

      dap.listeners.before.event_exited["config"] = function()
        vim.notify("Debugging exited", vim.log.levels.WARN, { title = "nvim-dap" })
        close(has_dapview)
      end
    end,
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        keys = {
          { "<leader>dB", ":lua require('dap-view').show_view('breakpoints')<CR>", desc = "show breakpoints" },
          { "<leader>du", "<cmd>lua require'dap-view'.toggle()<cr>", desc = "toggle dap view" },
        },
        ---@type dapview.Config
        opts = {
          winbar = {
            controls = {
              enabled = true,
            },
            default_section = "scopes",
          },
        },
      },
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },
    },
    keys = {
      { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "toggle breakpoint" },
      { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "continue" },
      { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "run last" },
      { "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", desc = "terminate" },
    },
  },
}
