require("utils"):create_keymap_group("<leader>f", "+find")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "buffers" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "diagnostics" },
      { "<leader>ff", "<cmd>Telescope git_files show_untracked=true<cr>", desc = "files" },
      { "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", desc = "files - all" },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({ additional_args = { "--hidden", "--glob=!.git" } })
        end,
        desc = "grep",
      },
      {
        "<leader>fG",
        function()
          require("telescope.builtin").live_grep({ additional_args = { "--unrestricted", "--unrestricted" } })
        end,
        desc = "grep - all",
      },
      { "<leader>fr", "<cmd>Telescope oldfiles only_cwd=true<cr>", desc = "recent files" },
      { "<leader>fR", "<cmd>Telescope oldfiles only_cwd=false<cr>", desc = "recent files - all" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "symbols" },
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
  {
    "willothy/flatten.nvim",
    lazy = false,
    opts = {
      window = {
        open = "alternate",
      },
    },
    priority = 1001,
  },
}
