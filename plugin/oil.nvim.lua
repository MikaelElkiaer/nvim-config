vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    version = "master",
  },
  {
    src = "https://github.com/stevearc/oil.nvim",
    version = "v2.15.0",
  },
})

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "<leader>o", '<cmd>lua require("oil").open()<cr>', { desc = "Oil cwd" })
