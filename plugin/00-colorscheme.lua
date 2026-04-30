vim.pack.add({
  {
    src = "https://github.com/sainnhe/gruvbox-material",
    version = "master",
  },
})

-- TODO: Apply overrides without relying on gruvbox.nvim
-- overrides = {
--   -- Remove color to discern from MiniDiffSignChange
--   CursorLineNr = { link = "CursorLine" },
--   -- Align with heirline.nvim and gitmux
--   MiniDiffSignChange = { link = "GruvboxYellow" },
--   -- A bit darker
--   StatusLine = { link = "StatusLineNC" },
--   -- Default "NormalFloat" is not visible
--   TreesitterContext = { link = "CursorLine" },
--   -- Defaults are not distinct
--   FlashCurrent = { link = "@text.todo" },
--   FlashLabel = { link = "@text.danger.comment" },
--   FlashMatch = { link = "@text.danger" },
--   CopilotEldritchHLGroup = { link = "GruvboxRed" },
--   -- Same color as lines
--   TreesitterContextLineNumber = { link = "CursorLine" },
-- },

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_disable_italic_comment = true
vim.g.gruvbox_material_transparent_background = 1
vim.cmd.colorscheme("gruvbox-material")
