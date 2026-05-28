vim.pack.add({
  {
    src = "https://github.com/error311/wayfinder.nvim",
    version = "v0.3.0",
  },
})

require("wayfinder").setup({})

vim.keymap.set("n", "<leader>wf", "<Plug>(WayfinderOpen)", { desc = "Wayfinder" })
