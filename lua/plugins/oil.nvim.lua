return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>o",
        '<cmd>lua require("oil").open()<cr>',
        desc = "Oil cwd",
      },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },
}
