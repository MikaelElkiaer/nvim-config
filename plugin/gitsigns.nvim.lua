vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
  numhl = true,
  signcolumn = false,
})

vim.keymap.set("n", "]h", "<cmd>Gitsigns nav_hunk next<cr>", { desc = "next hunk" })
vim.keymap.set("n", "[h", "<cmd>Gitsigns nav_hunk prev<cr>", { desc = "prev hunk" })
