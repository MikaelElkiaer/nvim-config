vim.pack.add({
  {
    src = "https://github.com/nvim-mini/mini.ai",
    version = "main",
  },
})

require("mini.ai").setup({
  -- Avoid conflict with incremental selection
  mappings = {
    around_next = "An",
    inside_next = "In",
    around_last = "Al",
    inside_last = "Il",
  },
})
