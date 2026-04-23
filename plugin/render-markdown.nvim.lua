vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    version = "master",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    version = "main",
  },
})

require("render-markdown").setup({
  file_types = { "markdown", "codecompanion" },
  html = {
    comment = {
      conceal = false,
    },
  },
})

vim.keymap.set("n", "<leader>um", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle Render Markdown" })
