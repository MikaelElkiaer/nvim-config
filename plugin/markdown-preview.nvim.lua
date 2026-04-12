vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })

-- markdown-preview doesn't have a lua .setup()

vim.keymap.set("n", "<leader>rm", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })
