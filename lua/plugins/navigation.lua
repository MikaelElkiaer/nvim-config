return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "buffers" },
      { "<leader>ff", "<cmd>Telescope git_files show_untracked=true<cr>", desc = "files" },
      { "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", desc = "files - all" },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({ additional_args = { "--hidden" } })
        end,
        desc = "grep",
      },
      {
        "<leader>fG",
        function()
          require("telescope.builtin").live_grep({ additional_args = { "--hidden", "--no-ignore" } })
        end,
        desc = "grep - no-ignore",
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
  {
    "moyiz/git-dev.nvim",
    cmd = { "GitDevOpen", "GitDevToggleUI", "GitDevRecents", "GitDevCleanAll" },
    keys = {
      {
        "<leader>gro",
        function()
          vim.cmd({ cmd = "GitDevOpen", args = { vim.fn.input("Repo: ") } })
        end,
        desc = "git repo open",
      },
      { "<leader>grt", "<cmd>GitDevToggleUI<cr>", desc = "git repo toggle" },
      { "<leader>grr", "<cmd>GitDevRecents<cr>", desc = "git repo recents" },
      { "<leader>grc", "<cmd>GitDevCleanAll<cr>", desc = "git repo clean" },
    },
    opts = {},
  },
}
