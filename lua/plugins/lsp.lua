return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim",
    },
    opts = {
      autoformat = false,
      ---@type lspconfig.options
      servers = {
        helm_ls = {
          cmd = { "helm_ls", "serve" },
          filetypes = { "helm" },
          mason = false,
        },
        omnisharp = {
          filetypes = { "cs", "csx" },
          root_dir = function(fname)
            if fname:sub(- #".csx") == ".csx" then
              return require("lspconfig").util.path.dirname(fname)
            end
            return vim.fn.getcwd()
          end,
        },
      },
      setup = {
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
        omnisharp = function(_, opts)
          opts.handlers = {
            ["textDocument/definition"] = require('omnisharp_extended').handler,
          }
          require("lazyvim.util").on_attach(function(client, _)
            -- INFO https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
            if client.name == "omnisharp" then
              client.server_capabilities.semanticTokensProvider.legend = {
                tokenModifiers = { "static" },
                tokenTypes = { "comment", "excluded", "identifier", "keyword", "keyword", "number", "operator",
                  "operator", "preprocessor", "string", "whitespace", "text", "static", "preprocessor", "punctuation",
                  "string", "string", "class", "delegate", "enum", "interface", "module", "struct", "typeParameter",
                  "field", "enumMember", "constant", "local", "parameter", "method", "method", "property", "event",
                  "namespace", "label", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml",
                  "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "regexp", "regexp", "regexp",
                  "regexp", "regexp", "regexp", "regexp", "regexp", "regexp" }
              }
            end
          end)
          return false
        end
      }
    }
  },
}
