vim.pack.add({
  {
    name = "yamlls-settings.nvim",
    src = "https://github.com/MikaelElkiaer/yamlls-settings.nvim",
    version = "main",
  },
})

require("yamlls-settings").setup()
