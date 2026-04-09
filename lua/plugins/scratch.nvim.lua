return {
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
}
