return {
  "sindrets/diffview.nvim",
  cmd = { "DiffViewOpen", "DiffviewOpen " },
  keys = {
    {
      "<leader>gdd",
      ":DiffviewOpen ",
      desc = "diffview cmdopen",
    },
    {
      "<leader>gdo",
      "<cmd>DiffviewOpen<cr>",
      desc = "diffview open",
    },
    {
      "<leader>gdc",
      "<cmd>DiffviewClose<cr>",
      desc = "diffview close",
    },
    {
      "<leader>gdh",
      "<cmd>DiffviewFileHistory %<cr>",
      desc = "diffview history",
    },
    {
      "<leader>gdH",
      "<cmd>DiffviewFileHistory<cr>",
      desc = "diffview history - all",
    },
  },
}
