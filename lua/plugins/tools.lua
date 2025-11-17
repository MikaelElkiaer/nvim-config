require("utils.init"):create_keymap_group("<leader>r", "+run")

return {
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
    keys = {
      { "<leader>rn", "<cmd>Scratch<cr>", desc = "new scratch" },
      { "<leader>rN", "<cmd>ScratchWithName<cr>", desc = "new scratch (named)" },
      { "<leader>ro", "<cmd>ScratchOpen<cr>", desc = "open scratch" },
    },
    opts = {
      filetypes = { "bash", "md", "txt" },
      file_picker = "snacks",
    },
  },
  {
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
  },
  {
    "MikaelElkiaer/base64.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>Bd", '<cmd>lua require("base64").decode()<cr>', desc = "base64 decode", mode = "x" },
      { "<leader>Be", '<cmd>lua require("base64").encode()<cr>', desc = "base64 encode", mode = "x" },
    },
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      {
        "<leader>rt",
        "<cmd>OverseerRun<cr>",
        desc = "Run task (Overseer)",
      },
      {
        "<leader>rT",
        "<cmd>OverseerToggle<cr>",
        desc = "Toggle task list (Overseer)",
      },
    },
    lazy = false,
    opts = {},
  },
}
