vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "<leader>o", '<cmd>lua require("oil").open()<cr>', { desc = "Oil cwd" })
