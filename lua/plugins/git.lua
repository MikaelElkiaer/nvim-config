require("utils.init"):create_keymap_group("<leader>g", "+git")

return {
  {
    "valorl/vcslink.nvim",
    cmd = { "VcsLinkLineCopy", "VcsLinkLineBrowse", "VcsLinkBufCopy", "VcsLinkBufBrowse" },
    init = function()
      require("utils.init"):create_keymap_group("<leader>gl", "+link")
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
    cmd = { "DiffViewOpen", "DiffviewOpen " },
    init = function()
      require("utils.init"):create_keymap_group("<leader>gd", "+diff")
    end,
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
  },
  {
    "pwntester/octo.nvim",
    cmd = { "Octo", "Octo " },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      require("utils.init"):create_keymap_group("<leader>go", "+octo")
    end,
    keys = {
      {
        "<leader>goo",
        ":Octo ",
        desc = "octo cmd",
      },
      {
        "<leader>goil",
        "<cmd>Octo issue list<cr>",
        desc = "octo issue list",
      },
      {
        "<leader>goic",
        "<cmd>Octo issue create<cr>",
        desc = "octo issue create",
      },
      {
        "<leader>gopl",
        "<cmd>Octo pr list<cr>",
        desc = "octo pr list",
      },
      {
        "<leader>gopc",
        "<cmd>Octo pr create<cr>",
        desc = "octo pr create",
      },
      {
        "<leader>gor",
        "<cmd>Octo review<cr>",
        desc = "octo review",
      },
    },
    opts = true,
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
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      numhl = true,
      signcolumn = false,
    },
  },
}
