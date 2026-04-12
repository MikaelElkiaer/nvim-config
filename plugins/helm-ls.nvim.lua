return {
  "qvalentin/helm-ls.nvim",
  ft = "helm",
  opts = {
    conceal_templates = {
      -- enable the replacement of templates with virtual text of their current values
      enabled = false, -- tree-sitter must be setup for this feature
    },
  },
}
