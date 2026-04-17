vim.pack.add({
  {
    src = "https://github.com/FabijanZulj/blame.nvim",
    version = "main",
  },
})

require("blame").setup({
  mappings = {
    close = "gq",
  },
})
vim.keymap.set("n", "<leader>gb", "<cmd>BlameToggle<cr>", { desc = "git blame" })
