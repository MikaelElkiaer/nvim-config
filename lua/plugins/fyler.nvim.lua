return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "stable", -- Use stable branch for production
  keys = {
    { "<leader>e", "<cmd>lua require('fyler').toggle({kind='split_left'})<cr>", desc = "Fyler - toggle" },
    { "<leader>E", "<cmd>Fyler kind=float<cr>", desc = "Fyler - float" },
  },
  lazy = false, -- Necessary for `default_explorer` to work properly
  opts = {
    integrations = {
      icon = "nvim_web_devicons",
    },
  },
}
