local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
  return
end

local servers = {
  "sumneko_lua",
  "cssls",
  "html",
  "tsserver",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "omnisharp",
  "dockerls",
  "terraformls",
  "helm_ls"
}

mason_lspconfig.setup {
  automatic_installation = {
  }
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local configs = require('lspconfig.configs')
if not configs.helm_ls then
  configs.helm_ls = {
    default_config = {
      cmd = { "helm_ls", "serve" },
      filetypes = { 'helm' },
      root_dir = function(fname)
        return lspconfig.util.root_pattern('Chart.yaml')(fname)
      end,
    },
  }
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  if server == "sumneko_lua" then
    local sumneko_opts = require "user.lsp.settings.sumneko_lua"
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server == "pyright" then
    local pyright_opts = require "user.lsp.settings.pyright"
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server == "omnisharp" then
    local omnisharp_opts = require "user.lsp.settings.omnisharp"
    opts = vim.tbl_deep_extend("force", omnisharp_opts, opts)
  end

  if server == "helm_ls" then
    local helmls_opts = {
      cmd = { "helm_ls", "serve" },
      filetypes = { 'helm' },
    }
    opts = vim.tbl_deep_extend("force", helmls_opts, opts)
  end

  lspconfig[server].setup(opts)
end
