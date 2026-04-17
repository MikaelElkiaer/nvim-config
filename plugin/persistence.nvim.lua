vim.pack.add({
  {
    src = "https://github.com/folke/persistence.nvim",
    version = "main",
  },
})

require("persistence").setup({})

vim.keymap.set("n", "<leader>X", '<cmd>lua require("persistence").save()<cr><cmd>restart lua require("persistence").load()<cr>', { desc = "Restart and restore session" })
vim.keymap.set("n", "<leader>R", '<cmd>lua require("persistence").load()<cr>', { desc = "Restore session" })
