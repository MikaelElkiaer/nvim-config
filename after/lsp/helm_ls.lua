return {
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
