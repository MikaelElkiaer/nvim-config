vim.pack.add({
  {
    src = "https://github.com/folke/persistence.nvim",
    version = "v3.1.0",
  },
})

require("persistence").setup({})

vim.keymap.set("n", "<leader>X", '<cmd>lua require("persistence").save()<cr><cmd>restart lua require("persistence").load()<cr>', { desc = "Restart and restore session" })
vim.keymap.set("n", "<leader>R", '<cmd>lua require("persistence").load()<cr>', { desc = "Restore session" })
