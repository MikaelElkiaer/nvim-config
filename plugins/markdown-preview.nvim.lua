return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  -- WARN: Might have to uninstall and run this again
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  keys = { {
    "<leader>rm",
    "<cmd>MarkdownPreviewToggle<cr>",
    desc = "Toggle Markdown Preview",
  } },
}
