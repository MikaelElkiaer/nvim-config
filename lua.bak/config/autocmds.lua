-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Run actionlint when changing a GitHub Actions workflow file
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    local success, lint = pcall(require, "lint")
    if not success then
      return
    end
    lint.try_lint("actionlint")
  end,
  pattern = "*.github/workflows/*.yaml",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    vim.bo.filetype = "yaml"
  end,
  pattern = vim.fn.expand("~") .. "/.kube/config*",
})
