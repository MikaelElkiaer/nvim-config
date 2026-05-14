vim.pack.add({
  {
    src = "https://github.com/shellRaining/hlchunk.nvim",
    version = "main",
  },
})

require("hlchunk").setup({
  chunk = {
    chars = {
      horizontal_line = "─", -- U+2500 (box drawing, not dash)
      vertical_line = "│",
      left_top = "╭",
      left_bottom = "╰",
      right_arrow = "─", -- U+2500 (box drawing, not dash)
    },
    duration = 0,
    enable = true,
    style = {
      { link = "@comment" },
      { link = "@exception" },
    },
    straight = false,
  },
  indent = {
    enable = true,
    style = {
      { link = "EndOfBuffer" },
    },
  },
  exclude_filetypes = {
    "help",
    "lazy",
    "notify",
    "toggleterm",
  },
})
