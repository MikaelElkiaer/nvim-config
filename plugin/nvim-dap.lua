vim.pack.add({ "https://github.com/mfussenegger/nvim-dap" })
vim.pack.add({ "https://github.com/igorlfs/nvim-dap-view" })
vim.pack.add({ "https://github.com/leoluz/nvim-dap-go" })

require("dap-view").setup({
  winbar = {
    controls = {
      enabled = true,
    },
    default_section = "scopes",
  },
})
require("dap-go").setup({})

local function init_dap(has_dapview)
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

local function close_dap(has_dapview)
  pcall(vim.keymap.del, "n", "<LocalLeader>b")
  pcall(vim.keymap.del, "n", "<LocalLeader>c")
  pcall(vim.keymap.del, "n", "<LocalLeader>g")
  pcall(vim.keymap.del, "n", "<LocalLeader>k")
  pcall(vim.keymap.del, "n", "<LocalLeader>l")
  pcall(vim.keymap.del, "n", "<LocalLeader>j")
  pcall(vim.keymap.del, "n", "<LocalLeader>h")
  pcall(vim.keymap.del, "n", "<LocalLeader>r")
  pcall(vim.keymap.del, "n", "<LocalLeader>s")
  pcall(vim.keymap.del, "n", "<LocalLeader>t")

  if has_dapview then
    pcall(vim.keymap.del, "n", "<LocalLeader>B")
    pcall(vim.keymap.del, "n", "<LocalLeader>E")
    pcall(vim.keymap.del, "n", "<LocalLeader>R")
    pcall(vim.keymap.del, "n", "<LocalLeader>S")
    pcall(vim.keymap.del, "n", "<LocalLeader>T")
    pcall(vim.keymap.del, "n", "<LocalLeader>W")
  end
end

-- dap config
local dap = require("dap")
local has_dapview, dapview = pcall(require, "dap-view")

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["config"] = function()
  vim.notify("Debugging started", vim.log.levels.INFO, { title = "nvim-dap" })
  init_dap(has_dapview)
  if has_dapview then
    dapview.open()
  end
end

dap.listeners.before.event_terminated["config"] = function()
  vim.notify("Debugging stopped", vim.log.levels.INFO, { title = "nvim-dap" })
  if has_dapview then
    dapview.close()
  end
  close_dap(has_dapview)
end

dap.listeners.before.event_exited["config"] = function()
  vim.notify("Debugging exited", vim.log.levels.WARN, { title = "nvim-dap" })
  close_dap(has_dapview)
end

-- global keys
vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = "toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", { desc = "continue" })
vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", { desc = "run last" })
vim.keymap.set("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", { desc = "terminate" })
vim.keymap.set("n", "<leader>dB", ":lua require('dap-view').show_view('breakpoints')<CR>", { desc = "show breakpoints" })
vim.keymap.set("n", "<leader>du", "<cmd>lua require'dap-view'.toggle()<cr>", { desc = "toggle dap view" })
