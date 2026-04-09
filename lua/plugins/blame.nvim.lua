return {
  "FabijanZulj/blame.nvim",
  cmd = { "BlameToggle" },
  keys = {
    { "<leader>gb", "<cmd>BlameToggle<cr>", desc = "git blame" },
  },
  opts = {
    mappings = {
      close = "gq",
    },
  },
}
