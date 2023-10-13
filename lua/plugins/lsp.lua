return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim",
      {
        "someone-stole-my-name/yaml-companion.nvim",
        config = function(_, _)
          require("telescope").load_extension("yaml_schema")
        end,
        keys = {
          { "<leader>ys", "<cmd>Telescope yaml_schema<cr>", "Select yaml schema for buffer" }
        }
      },
    },
    opts = function(_, opts)
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
          on_attach = function(client, bufnr)
            -- Use omnisharp_extended for decompilation
            -- stylua: ignore
            vim.keymap.set( "n", "gd", "<cmd>lua require('omnisharp_extended').telescope_lsp_definitions()<cr>", { buffer = bufnr, desc = "Goto Definition" })
          end,
          root_dir = function(fname)
            if fname:sub(-#".csx") == ".csx" then
              return require("lspconfig").util.path.dirname(fname)
            end
            local root = require("lspconfig.util").root_pattern("*.sln")(fname)
            return root or vim.fn.getcwd()
          end,
        },
        yamlls = require("yaml-companion").setup({
          lspconfig = {
            settings = {
              yaml = {
                keyOrdering = false,
              },
            },
          },
        }),
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
  {
    "glepnir/lspsaga.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
    event = "LspAttach",
    init = function()
      require("lazyvim.util").lsp.on_attach(function(_, buffer)
        vim.keymap.set("n", "<leader>cc", "<cmd>Lspsaga finder<CR>", { buffer = buffer, silent = true })
        vim.keymap.set("n", "<leader>cp", "<cmd>Lspsaga peek_type_definition<CR>", { buffer = buffer, silent = true })
        vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outline<CR>", { buffer = buffer, silent = true })
      end)
    end,
    opts = {
      lightbulb = {
        enable = false,
      },
      symbol_in_winbar = {
        enable = false,
      },
    },
  },
}
