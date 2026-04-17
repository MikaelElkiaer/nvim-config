vim.pack.add({
  {
    src = "https://github.com/iamcco/markdown-preview.nvim",
    version = "master",
  },
})

-- markdown-preview doesn't have a lua .setup()

vim.keymap.set("n", "<leader>rm", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })
