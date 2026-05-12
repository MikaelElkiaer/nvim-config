vim.pack.add({
  {
    src = "https://github.com/folke/todo-comments.nvim",
    version = "v1.5.0",
  },
})

require("todo-comments").setup({
  signs = false,
})

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next({ keywords = { "TODO" } })
end, { desc = "Todo next" })
vim.keymap.set("n", "]T", function()
  require("todo-comments").jump_next()
end, { desc = "Todo next - all" })
vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev({ keywords = { "TODO" } })
end, { desc = "Todo prev" })
vim.keymap.set("n", "[T", function()
  require("todo-comments").jump_prev()
end, { desc = "Todo prev - all" })
vim.keymap.set("n", "<leader>ft", function()
  Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo/Fix/Fixme" })
vim.keymap.set("n", "<leader>fT", function()
  Snacks.picker.todo_comments()
end, { desc = "Todo (all)" })
