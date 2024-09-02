return {
  {
    "valorl/vcslink.nvim",
    cmd = { "VcsLinkLineCopy", "VcsLinkLineBrowse", "VcsLinkBufCopy", "VcsLinkBufBrowse" },
    init = function()
      require("utils").create_keymap_group("<leader>gl", "+link")
    end,
    keys = {
      { "<leader>glc", "<cmd>VcsLinkLineCopy<cr>", desc = "copy line" },
      { "<leader>glC", "<cmd>VcsLineBufCopy<cr>", desc = "copy buffer" },
      { "<leader>glb", "<cmd>VcsLinkLineBrowse<cr>", desc = "browse line" },
      { "<leader>glB", "<cmd>VcsLinkBufBrowse<cr>", desc = "browse buffer" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen " },
    keys = {
      {
        "<leader>gdo",
        "<cmd>DiffviewOpen<cr>",
        desc = "diffview open",
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
        "<leader>goi",
        "<cmd>Octo issue list<cr>",
        desc = "octo issue",
      },
      {
        "<leader>gop",
        "<cmd>Octo pr<cr>",
        desc = "octo PR",
      },
    },
    opts = {},
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
