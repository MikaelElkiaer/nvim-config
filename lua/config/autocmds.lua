-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Run actionlint when changing a GitHub Actions workflow file
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    local lint, _ = pcall(require, "lint")
    if not lint then
      return
    end
    require("lint").try_lint("actionlint")
  end,
  pattern = "*.github/workflows/*.yaml",
})
