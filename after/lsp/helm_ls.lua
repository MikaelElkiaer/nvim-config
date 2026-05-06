---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.helm_ls
  settings = {
    ["helm-ls"] = {
      valuesFiles = {
        additionalValuesFilesGlobPattern = "*values*.yaml",
      },
      yamlls = {
        path = { "yaml-schema-router" },
      },
    },
  },
}
