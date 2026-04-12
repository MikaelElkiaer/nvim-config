vim.pack.add({ "https://github.com/qvalentin/helm-ls.nvim" })

require("helm-ls").setup({
  conceal_templates = {
    -- enable the replacement of templates with virtual text of their current values
    enabled = false, -- tree-sitter must be setup for this feature
  },
})
