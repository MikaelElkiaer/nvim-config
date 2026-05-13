vim.pack.add({
  {
    src = "https://github.com/folke/which-key.nvim",
    version = "main",
  },
})

require("which-key").setup({
  win = { border = "rounded" },
})
