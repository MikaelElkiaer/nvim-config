-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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

-- Treat kubeconfigs as yaml
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    vim.bo.filetype = "yaml"
  end,
  pattern = vim.fn.expand("~") .. "/.kube/config*",
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})
