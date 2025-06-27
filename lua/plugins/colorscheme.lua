return {
  {
    "ellisonleao/gruvbox.nvim",
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.o.background = "dark"
      vim.cmd([[colorscheme gruvbox]])
    end,
    lazy = false,
    opts = {
      bold = false,
      italic = {
        strings = false,
        comments = false,
        operators = false,
        folds = false,
      },
      contrast = "hard",
      overrides = {
        -- No color
        CursorLineNr = { link = "CursorLine" },
        -- Align with heirline.nvim and gitmux
        GitSignsChangeNr = { link = "GruvboxYellow" },
        -- A bit darker
        StatusLine = { link = "StatusLineNC" },
      },
      transparent_mode = true,
    },
    priority = 1000,
  },
}
