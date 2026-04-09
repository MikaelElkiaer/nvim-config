return {
  "arjunmahishi/flow.nvim", -- run code from file (incl. markdown code blocks)
  cmd = { "FlowRunFile", "FlowRunMDBlock", "FlowRunSelected" },
  keys = {
    { "<leader>rR", "<cmd>FlowRunFile<cr>", desc = "run file" },
    { "<leader>rr", "<cmd>FlowRunMDBlock<cr>", desc = "run block" },
    { "<leader>rr", "<cmd>FlowRunSelected<cr>", desc = "run selected", mode = "v" },
  },
  opts = {
    filetype_cmd_map = {
      csx = "dotnet script eval <<-EOF\n%s\nEOF",
      hurl = "hurl <<-EOF\n%s\nEOF",
    },
    output = {
      buffer = true,
      split_cmd = "100vsplit",
    },
  },
}
