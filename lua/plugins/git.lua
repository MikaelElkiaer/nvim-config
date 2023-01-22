return {
  -- grab VCS (GitHub etc.) links from current line
  {
    "valorl/vcslink.nvim",
    cmd = { "VcsLinkCopy", "VcsLinkBrowse" }
  },
  -- navigation and simple view for git conflicts
  {
    'akinsho/git-conflict.nvim',
    cmd = { "GitConflictListQf" },
    opts = true,
  },
}
