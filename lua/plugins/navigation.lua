return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    },
    opts = function()
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/oil.nvim",
    cmd = { "Oil " },
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
