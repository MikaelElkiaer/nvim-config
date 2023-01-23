return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "Hoffs/omnisharp-extended-lsp.nvim",
      },
    },
    opts = function(_, opts)
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
      require("lspconfig").helm_ls.setup({
        cmd = { "helm_ls", "serve" },
        filetypes = { "helm" },
      })
      local more_opts = {
        autoformat = false,
        ---@type lspconfig.options
        servers = {
          omnisharp = {
            filetypes = { "cs", "csx" },
            handlers = {
              ["textDocument/definition"] = require("omnisharp_extended").handler,
            },
            root_dir = function(fname)
              if fname:sub(- #".csx") == ".csx" then
                return require("lspconfig").util.path.dirname(fname)
              end
              return vim.fn.getcwd()
            end,
          },
        },
      }
      vim.tbl_deep_extend("force", opts, more_opts)
    end,
  },
}
