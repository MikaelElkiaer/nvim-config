vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    version = "master",
  },
  {
    src = "https://github.com/MunifTanjim/nui.nvim",
    version = "main",
  },
  {
    src = "https://github.com/folke/noice.nvim",
    version = "main",
  },
})

require("noice").setup({
  cmdline = {
    view = "cmdline",
  },
  presets = {
    lsp_doc_border = true,
  },
})
