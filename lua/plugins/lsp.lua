require("utils").create_keymap_group("<leader>c", "+code")
require("utils").create_keymap_group("<leader>y", "+yaml")

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
      },
    },
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
        go = { "gofmt" },
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
      local lspconfig = require("lspconfig")
      local blink = require("blink.cmp")
      for server, config in pairs(opts.servers) do
        if type(config) == "function" then
          config = config({})
        end
        config.capabilities = blink.get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
    dependencies = {
      {
        "seblj/roslyn.nvim",
        config = function(_, opts)
          opts.config = {
            on_attach = on_attach,
          }
          require("roslyn").setup(opts)
        end,
        opts = {
          exe = { "Microsoft.CodeAnalysis.LanguageServer" },
        },
      },
      {
        "someone-stole-my-name/yaml-companion.nvim",
        config = function(_, _)
          require("telescope").load_extension("yaml_schema")
        end,
        keys = {
          { "<leader>ys", "<cmd>Telescope yaml_schema<cr>", desc = "YAML schema picker" },
        },
      },
      "saghen/blink.cmp",
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
        yamlls = function(config)
          return require("yaml-companion").setup(config)
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
    "saghen/blink.cmp",
    -- lazy loading handled internally
    lazy = false,
    -- use a release tag to download pre-built binaries
    version = "v0.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          window = {
            border = "rounded",
          },
        },
        list = {
          selection = "manual",
        },
        menu = {
          auto_show = false,
          border = "rounded",
          winhighlight = "Pmenu:BlinkCmpMenu,Pmenu:BlinkCmpMenuBorder,PmenuSel:BlinkCmpMenuSelection,Search:None",
        },
      },
      keymap = {
        preset = "default",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
      -- Conflicts with noice.nvim
      signature = { enabled = false },
      sources = {
        completion = {
          enabled_providers = { "lsp", "path", "buffer" },
        },
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    cmd = "Lspsaga",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    keys = {
      { "gd", "<cmd>Lspsaga peek_definition<cr>", desc = "lspsaga - peek definition" },
      { "gD", "<cmd>Lspsaga goto_definition<cr>", desc = "lspsaga - goto definition" },
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "lspsaga - hover doc" },
      { "<leader>cc", "<cmd>Lspsaga finder<cr>", desc = "lspsaga - finder" },
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "lspsaga - code actions", mode = { "n", "x" } },
      { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "lspsaga - rename" },
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
}
