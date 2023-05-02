return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim",
    },
    opts = function(_, opts)
      opts.autoformat = false
      ---@type lspconfig.options
      opts.servers = vim.tbl_extend("force", opts.servers, {
        helm_ls = {
          cmd = { "helm_ls", "serve" },
          filetypes = { "helm" },
          mason = false,
        },
        omnisharp = {
          filetypes = { "cs", "csx" },
          handlers = {
            ["textDocument/definition"] = require("omnisharp_extended").handler,
          },
          mason = false,
          on_attach = function(client, _)
            --INFO: https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
            local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
            for i, v in ipairs(tokenModifiers) do
              local tmp = string.gsub(v, " ", "_")
              tokenModifiers[i] = string.gsub(tmp, "-_", "")
            end
            local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
            for i, v in ipairs(tokenTypes) do
              local tmp = string.gsub(v, " ", "_")
              tokenTypes[i] = string.gsub(tmp, "-_", "")
            end
          end,
          root_dir = function(fname)
            if fname:sub(-#".csx") == ".csx" then
              return require("lspconfig").util.path.dirname(fname)
            end
            return vim.fn.getcwd()
          end,
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
      })
      opts.setup = vim.tbl_extend("force", opts.setup, {
        helm_ls = function(_, _)
          local configs = require("lspconfig.configs")
          if not configs.helm_ls then
            configs.helm_ls = {
              default_config = {
                cmd = { "helm_ls", "serve" },
                filetypes = { "helm" },
                root_dir = function(fname)
                  local util = require("lspconfig.util")
                  return util.root_pattern("Chart.yaml")(fname)
                end,
              },
            }
          end
          return false
        end,
      })
    end,
  },
}
