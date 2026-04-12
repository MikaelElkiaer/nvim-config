vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-context" })
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("treesitter-context").setup({
  mode = "cursor",
  max_lines = 3,
})

vim.keymap.set("n", "<leader>ut", function()
  local tsc = require("treesitter-context")
  tsc.toggle()
end, { desc = "Toggle Treesitter Context" })
