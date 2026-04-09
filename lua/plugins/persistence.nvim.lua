return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  keys = {
    {
      "<leader>X",
      '<cmd>lua require("persistence").save()<cr><cmd>restart lua require("persistence").load()<cr>',
      desc = "Restart and restore session",
    },
    {
      "<leader>R",
      '<cmd>lua require("persistence").load()<cr>',
      desc = "Restore session",
    },
  },
  opts = true,
}
