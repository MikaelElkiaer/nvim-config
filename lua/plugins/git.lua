require("utils"):create_keymap_group("<leader>g", "+git")

return {
  {
    "valorl/vcslink.nvim",
    cmd = { "VcsLinkLineCopy", "VcsLinkLineBrowse", "VcsLinkBufCopy", "VcsLinkBufBrowse" },
    init = function()
      require("utils"):create_keymap_group("<leader>gl", "+link")
    end,
    keys = {
      { "<leader>glc", "<cmd>VcsLinkLineCopy<cr>", desc = "copy line" },
      { "<leader>glC", "<cmd>VcsLinkBufCopy<cr>", desc = "copy buffer" },
      { "<leader>glb", "<cmd>VcsLinkLineBrowse<cr>", desc = "browse line" },
      { "<leader>glB", "<cmd>VcsLinkBufBrowse<cr>", desc = "browse buffer" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen " },
    init = function()
      require("utils"):create_keymap_group("<leader>gd", "+diff")
    end,
    keys = {
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
  },
  {
    "pwntester/octo.nvim",
    cmd = { "Octo " },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>go",
        ":Octo ",
        desc = "octo",
      },
    },
    opts = {
      gh_env = {
        -- INFO: Needed for gh to access keyring
        -- - see https://github.com/pwntester/octo.nvim/issues/568
        DBUS_SESSION_BUS_ADDRESS = vim.env["DBUS_SESSION_BUS_ADDRESS"]
      }
    },
  },
  {
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
  },
}
