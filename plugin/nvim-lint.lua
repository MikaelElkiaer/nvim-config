vim.pack.add({
  {
    src = "https://github.com/mfussenegger/nvim-lint",
    version = "master",
  },
})

local lint = require("lint")
lint.linters.hush = {
  args = { "--check" },
  cmd = "hush",
  ignore_exitcode = true,
  name = "hush",
  parser = require("lint.parser").from_pattern(
    [[^(.*): (.*) %(line (%d+), column (%d+)%) %- (.*)$]],
    { "severity", "file", "lnum", "col", "message" },
    { ["Error"] = vim.diagnostic.severity.ERROR }
  ),
  stdin = false,
  stream = "stderr",
}
lint.linters_by_ft = {
  dockerfile = { "hadolint" },
  go = { "golangcilint" },
  html = { "htmlhint" },
  hush = { "hush" },
  markdown = { "markdownlint-cli2" },
  yaml = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
