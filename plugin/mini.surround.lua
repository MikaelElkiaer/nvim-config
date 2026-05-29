vim.pack.add({
  {
    src = "https://github.com/nvim-mini/mini.surround",
    version = "main",
  },
})

require("mini.surround").setup({
  mappings = {
    add = "Sa", -- Add surrounding in Normal and Visual modes
    delete = "Sd", -- Delete surrounding
    find = "Sf", -- Find surrounding (to the right)
    find_left = "SF", -- Find surrounding (to the left)
    highlight = "Sh", -- Highlight surrounding
    replace = "Sr", -- Replace surrounding
  },
})
