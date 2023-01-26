return {
  -- grab VCS (GitHub etc.) links from current line
  {
    "valorl/vcslink.nvim",
    cmd = { "VcsLinkCopy", "VcsLinkBrowse" },
  },
  -- navigation and simple view for git conflicts
  {
    "akinsho/git-conflict.nvim",
    cmd = { "GitConflictListQf", "GitConflictNextConflict", "GitConflictPrevConflict" },
    keys = {
      { "<leader>gC", "<cmd>GitConflictListQf<cr>", desc = "conflicts" },
      { "]C", "<cmd>GitConflictNextConflict<cr>", desc = "next conflict" },
      { "[C", "<cmd>GitConflictPrevConflict<cr>", desc = "previous conflict" },
    },
    opts = true,
  },
}
