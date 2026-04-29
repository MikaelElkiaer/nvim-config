vim.pack.add({
  {
    src = "https://github.com/ellisonleao/gruvbox.nvim",
    version = "main",
  },
})

require("gruvbox").setup({
  bold = false,
  italic = {
    strings = false,
    comments = false,
    operators = false,
    folds = false,
  },
  contrast = "hard",
  overrides = {
    -- Remove color to discern from MiniDiffSignChange
    CursorLineNr = { link = "CursorLine" },
    -- Align with heirline.nvim and gitmux
    MiniDiffSignChange = { link = "GruvboxYellow" },
    -- A bit darker
    StatusLine = { link = "StatusLineNC" },
    -- Default "NormalFloat" is not visible
    TreesitterContext = { link = "CursorLine" },
    -- Defaults are not distinct
    FlashCurrent = { link = "@text.todo" },
    FlashLabel = { link = "@text.danger.comment" },
    FlashMatch = { link = "@text.danger" },
    CopilotEldritchHLGroup = { link = "GruvboxRed" },
    -- Same color as lines
    TreesitterContextLineNumber = { link = "CursorLine" },
  },
  transparent_mode = true,
})
vim.cmd([[colorscheme gruvbox]])
