local function get_capabilities_factory()
  local blink_ok, blink = pcall(require, "blink.cmp")
  if blink_ok then
    return blink.get_lsp_capabilities
  end

  return function(capabilities)
    return capabilities
  end
end

vim.pack.add({
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    version = "master",
  },
})

local opts = {
  servers = {
    bashls = {},
    dockerls = {},
    gopls = {},
    helm_ls = {
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
    },
    jsonls = {},
    jsonnet_ls = {},
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
    pylsp = {},
    terraform_lsp = {},
    ts_ls = {},
    yamlls = function()
      return {
        cmd = { "yaml-schema-router" },
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
    end,
    marksman = {},
    nil_ls = {},
  },
}

local capabilities_factory = get_capabilities_factory()
for server, config in pairs(opts.servers) do
  if type(config) == "function" then
    local capabilities = capabilities_factory({})
    config = config({ lspconfig = { capabilities = capabilities } })
  else
    config.capabilities = capabilities_factory(config.capabilities)
  end
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
