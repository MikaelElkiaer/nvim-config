return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    keys = {
      { "]h", "<cmd>Gitsigns nav_hunk next<cr>", desc = "next hunk" },
      { "[h", "<cmd>Gitsigns nav_hunk prev<cr>", desc = "prev hunk" },
    },
    opts = {
      numhl = true,
      signcolumn = false,
    },
  },
}
