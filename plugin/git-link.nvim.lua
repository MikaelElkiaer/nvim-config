vim.pack.add({ "https://github.com/juacker/git-link.nvim" })

-- git-link doesn't seem to have a standard .setup() in the spec, but we'll add it just in case if it's common
-- Actually, the module name is git-link.main in the keys.

vim.keymap.set({ "n", "x" }, "<leader>glc", function()
  require("git-link.main").copy_line_url()
end, { desc = "Copy code link to clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>glo", function()
  require("git-link.main").open_line_url()
end, { desc = "Open code link in browser" })
