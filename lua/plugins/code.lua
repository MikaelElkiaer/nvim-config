require("utils.init"):create_keymap_group("<leader>c", "+code")

local function on_attach(client, bufnr)
  local has_lspsaga = vim.fn.exists(":Lspsaga") == 2
  local goto_definition = has_lspsaga and "<cmd>Lspsaga goto_definition<cr>"
  local peek_definition = has_lspsaga and "<cmd>Lspsaga peek_definition<cr>"
  local hover_doc = has_lspsaga and "<cmd>Lspsaga hover_doc<cr>"
  local code_action = has_lspsaga and "<cmd>Lspsaga code_action<cr>" or vim.lsp.buf.code_action
  local rename = has_lspsaga and "<cmd>Lspsaga rename<cr>" or vim.lsp.buf.rename

  if client.server_capabilities.definitionProvider then
    if goto_definition then
      vim.keymap.set("n", "gd", goto_definition, { buffer = bufnr, desc = "definition" })
    end
    if peek_definition then
      vim.keymap.set("n", "gD", peek_definition, { buffer = bufnr, desc = "definition - peek" })
    end
  end
  if client.server_capabilities.codeActionProvider and code_action then
    vim.keymap.set({ "n", "x" }, "<leader>ca", code_action, { buffer = bufnr, desc = "code actions" })
  end
  if client.server_capabilities.hoverProvider and hover_doc then
    vim.keymap.set("n", "K", hover_doc, { buffer = bufnr, desc = "hover doc" })
  end
  if client.server_capabilities.renameProvider and rename then
    vim.keymap.set("n", "<leader>cr", rename, { buffer = bufnr, desc = "rename" })
  end
end

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
        html = { "htmlhint" },
        hush = { "hush" },
        markdown = { "markdownlint-cli2" },
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
          config = config({ lspconfig = { capabilities = capabilities, on_attach = on_attach } })
        else
          config.capabilities = capabilities_factory(config.capabilities)
          config.on_attach = on_attach
        end
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
    dependencies = {
      {
        "imroc/kubeschema.nvim",
        opts = {
          schema = {
            -- default schema
            url = "https://github.com/imroc/kubeschemas",
            -- WARN: Does not work, do not know why yet
            -- url = "https://github.com/datreeio/CRDs-catalog",
            dir = vim.fn.stdpath("data") .. "/kubernetes/schemas",
          },
        },
      },
    },
    event = "BufEnter",
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "LSP Info" },
    },
    opts = {
      servers = {
        bashls = {},
        dockerls = {},
        gopls = {},
        helm_ls = {},
        jsonls = {},
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
            capabilities = {
              workspace = {
                didChangeConfiguration = {
                  -- kubeschema.nvim relies on workspace.didChangeConfiguration to implement dynamic schema loading of yamlls.
                  -- It is recommended to enable dynamicRegistration (it's also OK not to enable it, but warning logs will be
                  -- generated from LspLog, but it will not affect the function of kubeschema.nvim)
                  dynamicRegistration = true,
                },
              },
            },
            -- IMPORTANT!!! Set kubeschema's on_attch to yamlls so that kubeschema can dynamically and accurately match the
            -- corresponding schema file based on the yaml file content (APIVersion and Kind).
            on_attach = require("kubeschema").on_attach,
            on_new_config = function(new_config)
              new_config.settings.yaml = vim.tbl_deep_extend("force", new_config.settings.yaml or {}, {
                schemaStore = {
                  enable = false,
                },
                -- Use other schemas from SchemaStore
                -- https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json
                schemas = require("schemastore").yaml.schemas({
                  -- Optional ignore schemas from SchemaStore, each item is a schema name in SchemaStore's catalog.json
                  ignore = {
                    -- Rancher Fleet's fileMatch is 'fleet.yaml', which may conflict with the kubernetes yaml file of the same name.
                    -- e.g. https://github.com/googleforgames/agones/blob/main/examples/fleet.yaml
                    "Rancher Fleet",
                  },
                  -- Optional extra schemas to add to the schemas list
                  extra = {
                    {
                      name = "Example",
                      description = "Example YAML Schema",
                      fileMatch = "**/.example/job.yml",
                      url = "https://example.com/example-schema.json",
                    },
                  },
                }),
              })
            end,
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
    "seblj/roslyn.nvim",
    config = function(_, opts)
      local capabilities_factory = get_capabilities_factory()
      vim.lsp.config("roslyn", {
        capabilities = capabilities_factory(opts.config and opts.config.capabilities),
        cmd = {
          "Microsoft.CodeAnalysis.LanguageServer",
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
          "--stdio",
        },
        on_attach = on_attach,
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })
      require("roslyn").setup(opts)
    end,
    ft = "cs",
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
    "nvimdev/lspsaga.nvim",
    cmd = "Lspsaga",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>cc", "<cmd>Lspsaga finder<cr>", desc = "lspsaga" },
    },
    opts = {
      code_action = {
        keys = {
          quit = { "q", "<esc>" },
        },
      },
      lightbulb = {
        enable = false,
      },
      symbol_in_winbar = {
        enable = false,
      },
    },
  },
  {
    { "towolf/vim-helm", ft = "helm" },
  },
  {
    "danymat/neogen",
    cmd = { "Neogen" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      languages = {
        cs = {
          template = {
            annotation_convention = "xmldoc",
          },
        },
      },
    },
  },
}
