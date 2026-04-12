vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
vim.pack.add({ "https://github.com/MunifTanjim/nui.nvim" })
vim.pack.add({ "https://github.com/folke/noice.nvim" })

require("noice").setup({
  cmdline = {
    view = "cmdline",
  },
  presets = {
    lsp_doc_border = true,
  },
})
