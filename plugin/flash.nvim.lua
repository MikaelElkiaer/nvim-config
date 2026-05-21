vim.pack.add({
  {
    src = "https://github.com/folke/flash.nvim",
    version = "main",
  },
})

require("flash").setup({})

vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").jump()
end, { desc = "Flash" })
