require("utils.init"):create_keymap_group("<leader>c", "+code")

local function get_capabilities_factory()
  local blink_ok, blink = pcall(require, "blink.cmp")
  if blink_ok then
    return blink.get_lsp_capabilities
  end

  return function(capabilities)
    return capabilities
  end
end

return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        desc = "format",
        mode = { "n", "x" },
      },
    },
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
        go = { "gofmt" },
        html = { "html_beautify" },
        javascript = { "prettierd" },
        jsonc = { "jq" },
        lua = { "stylua" },
        markdown = { "markdownlint-cli2" },
        nix = { "nixfmt" },
        sh = { "shfmt" },
        toml = { "taplo" },
        yaml = { "yq" },
        xml = { "xmlformat" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function(plugin, _)
      local lint = require("lint")
      lint.linters.hush = {
        args = { "--check" },
        cmd = "hush",
        ignore_exitcode = true,
        name = "hush",
        parser = require("lint.parser").from_pattern(
          [[^(.*): (.*) %(line (%d+), column (%d+)%) %- (.*)$]],
          { "severity", "file", "lnum", "col", "message" },
          { ["Error"] = vim.diagnostic.severity.ERROR }
        ),
        stdin = false,
        stream = "stderr",
      }
      lint.linters_by_ft = {
        dockerfile = { "hadolint" },
        go = { "golangcilint" },
        html = { "htmlhint" },
        hush = { "hush" },
        markdown = { "markdownlint-cli2" },
        yaml = { "yamllint" },
      }
      vim.api.nvim_create_autocmd(plugin.event, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
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
    end,
    event = "BufEnter",
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "LSP Info" },
    },
    opts = {
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
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    "qvalentin/helm-ls.nvim",
    ft = "helm",
    opts = {
      conceal_templates = {
        -- enable the replacement of templates with virtual text of their current values
        enabled = false, -- tree-sitter must be setup for this feature
      },
    },
  },
}
