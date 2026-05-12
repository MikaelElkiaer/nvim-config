vim.pack.add({
  {
    src = "https://github.com/folke/which-key.nvim",
    version = "v3.17.0",
  },
})

require("which-key").setup({
  win = { border = "rounded" },
})
