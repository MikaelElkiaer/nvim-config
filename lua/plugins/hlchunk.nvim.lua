return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    chunk = {
      chars = {
        horizontal_line = "—", -- "Em", not "En" dash
        vertical_line = "│",
        left_top = "╭",
        left_bottom = "╰",
        right_arrow = "—", -- "Em", not "En" dash
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
