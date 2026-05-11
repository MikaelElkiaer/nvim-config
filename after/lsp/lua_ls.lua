---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      completion = {
        callSnippet = "Disable",
        keywordSnippet = "Disable",
      },
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}
