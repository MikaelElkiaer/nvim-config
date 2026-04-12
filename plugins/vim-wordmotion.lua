return {
  "chaoren/vim-wordmotion",
  event = "VeryLazy",
  init = function()
    vim.g.wordmotion_prefix = "<bs>"
  end,
  keys = { "<bs>" },
}
