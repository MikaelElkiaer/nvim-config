vim.pack.add({
  {
    src = "https://github.com/pwntester/octo.nvim",
    version = "master",
  },
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
    version = "master",
  },
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    version = "master",
  },
  {
    src = "https://github.com/folke/snacks.nvim",
    version = "main",
  },
})

require("octo").setup({
  picker = "snacks",
})

vim.keymap.set("n", "<leader>goo", ":Octo ", { desc = "octo cmd" })
vim.keymap.set("n", "<leader>goil", "<cmd>Octo issue list<cr>", { desc = "octo issue list" })
vim.keymap.set("n", "<leader>goic", "<cmd>Octo issue create<cr>", { desc = "octo issue create" })
vim.keymap.set("n", "<leader>gopl", "<cmd>Octo pr list<cr>", { desc = "octo pr list" })
vim.keymap.set("n", "<leader>gopc", "<cmd>Octo pr create<cr>", { desc = "octo pr create" })
vim.keymap.set("n", "<leader>gor", "<cmd>Octo review<cr>", { desc = "octo review" })
