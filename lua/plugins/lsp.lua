return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Decodetalkers/csharpls-extended-lsp.nvim",
    },
    opts = {
      autoformat = false,
      ---@type lspconfig.options
      servers = {
        csharp_ls = {
          filetypes = { "cs", "csx" },
          root_dir = function(fname)
            if fname:sub(-#".csx") == ".csx" then
              return require("lspconfig").util.path.dirname(fname)
            end
            return vim.fn.getcwd()
          end,
        },
        helm_ls = {
          cmd = { "helm_ls", "serve" },
          filetypes = { "helm" },
          mason = false,
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
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
        csharp_ls = function(_, opts)
          opts.handlers = {
            ["textDocument/definition"] = require("csharpls_extended").handler,
          }
          return false
        end,
      },
    },
  },
}
