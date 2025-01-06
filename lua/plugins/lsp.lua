require("utils"):create_keymap_group("<leader>c", "+code")

local function on_attach(client, bufnr)
  local has_lspsaga = vim.fn.exists(":Lspsaga") == 2
  local goto_definition = has_lspsaga and "<cmd>Lspsaga goto_definition<cr>" or vim.lsp.buf.definition
  local goto_implementation = vim.lsp.buf.implementation
  local goto_references = vim.lsp.buf.references
  local peek_definition = has_lspsaga and "<cmd>Lspsaga peek_definition<cr>"
  local hover_doc = has_lspsaga and "<cmd>Lspsaga hover_doc<cr>" or vim.lsp.buf.hover
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
  if client.server_capabilities.implementationProvider and goto_implementation then
    vim.keymap.set("n", "gi", goto_implementation, { buffer = bufnr, desc = "implementation" })
  end
  if client.server_capabilities.referencesProvider and goto_references then
    vim.keymap.set("n", "gr", goto_references, { buffer = bufnr, desc = "references" })
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

  return function(_) end
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
      local capabilities_factory = get_capabilities_factory()
      for server, config in pairs(opts.servers) do
        if type(config) == "function" then
          config = config({})
        end
        config.capabilities = capabilities_factory(config.capabilities)
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
    end,
    dependencies = {
      "someone-stole-my-name/yaml-companion.nvim",
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
    "seblj/roslyn.nvim",
    config = function(_, opts)
      local capabilities_factory = get_capabilities_factory()
      vim.tbl_extend("force", opts, {
        config = {
          capabilities = capabilities_factory(opts.config and opts.config.capabilities),
        },
      })
      require("roslyn").setup(opts)
    end,
    ft = "cs",
    opts = {
      config = {
        on_attach = on_attach,
      },
      exe = { "Microsoft.CodeAnalysis.LanguageServer" },
    },
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    config = function(_, _)
      require("telescope").load_extension("yaml_schema")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    keys = {
      { "<leader>cy", "<cmd>Telescope yaml_schema<cr>", desc = "YAML schema picker" },
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
        default = {
          "lsp",
          "path",
          "buffer",
        },
      },
    },
  },
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
}
