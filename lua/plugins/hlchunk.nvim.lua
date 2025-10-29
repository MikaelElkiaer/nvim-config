return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
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
    },
    indent = {
      enable = true,
      style = {
        { link = "EndOfBuffer" },
      },
    },
    exclude_filetypes = {
      "help",
      "dashboard",
      "lazy",
      "notify",
      "toggleterm",
      "wk", -- which-key
    },
  },
}
