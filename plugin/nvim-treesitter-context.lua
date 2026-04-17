vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
    version = "master",
  },
})
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
})

require("treesitter-context").setup({
  mode = "cursor",
  max_lines = 3,
})

vim.keymap.set("n", "<leader>ut", function()
  local tsc = require("treesitter-context")
  tsc.toggle()
end, { desc = "Toggle Treesitter Context" })
