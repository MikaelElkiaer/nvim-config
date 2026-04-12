vim.pack.add({ "https://github.com/FabijanZulj/blame.nvim" })

require("blame").setup({
  mappings = {
    close = "gq",
  },
})
vim.keymap.set("n", "<leader>gb", "<cmd>BlameToggle<cr>", { desc = "git blame" })
