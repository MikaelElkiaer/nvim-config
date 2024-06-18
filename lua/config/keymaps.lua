vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent decrease" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent increase" })
