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
    "akinsho/git-conflict.nvim",
    cmd = { "GitConflictListQf", "GitConflictNextConflict", "GitConflictPrevConflict" },
    keys = {
      { "<leader>gC", "<cmd>GitConflictListQf<cr>", desc = "conflicts" },
      { "]g", "<cmd>GitConflictNextConflict<cr>", desc = "next conflict" },
      { "[g", "<cmd>GitConflictPrevConflict<cr>", desc = "previous conflict" },
    },
    opts = {
      default_mappings = {
        ours = "Co",
        theirs = "Ct",
        none = "C0",
        both = "Cb",
        next = "Cn",
        prev = "Cp",
      },
      list_opener = function()
        require("trouble").open("quickfix")
      end,
    },
  },
  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },
}
