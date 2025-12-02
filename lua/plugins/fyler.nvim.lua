return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "stable", -- Use stable branch for production
  keys = {
    { "<leader>e", "<cmd>lua require('fyler').toggle()<cr>", desc = "Fyler" },
    { "<leader>E", "<cmd>Fyler<cr>", desc = "Fyler - split" },
  },
  lazy = false, -- Necessary for `default_explorer` to work properly
  opts = {
    integrations = {
      icon = "nvim_web_devicons",
    },
    -- WARN: Does not work
    views = {
      win = {
        kind = "split_left",
      },
    },
  },
}
