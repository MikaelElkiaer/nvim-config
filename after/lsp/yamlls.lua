---@type vim.lsp.Config
return {
  cmd = { "yaml-schema-router" },
  ---@type lspconfig.settings.yamlls
  settings = {
    yaml = {
      customTags = {
        "!override mapping",
        "!override scalar",
        "!override sequence",
        "!reset mapping",
        "!reset scalar",
        "!reset sequence",
      },
    },
  },
}
