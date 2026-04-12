vim.pack.add({ "https://github.com/sindrets/diffview.nvim" })

require("diffview").setup({})

vim.keymap.set("n", "<leader>gdd", ":DiffviewOpen ", { desc = "diffview cmdopen" })
vim.keymap.set("n", "<leader>gdo", "<cmd>DiffviewOpen<cr>", { desc = "diffview open" })
vim.keymap.set("n", "<leader>gdc", "<cmd>DiffviewClose<cr>", { desc = "diffview close" })
vim.keymap.set("n", "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", { desc = "diffview history" })
vim.keymap.set("n", "<leader>gdH", "<cmd>DiffviewFileHistory<cr>", { desc = "diffview history - all" })
