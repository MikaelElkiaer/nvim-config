vim.pack.add({
  {
    src = "https://github.com/nvim-mini/mini.diff",
    version = "main",
  },
})

require("mini.diff").setup({})

vim.keymap.set("n", "<leader>uh", function()
  MiniDiff.toggle_overlay(0)
end, { desc = "Toggle diff overlay" })
