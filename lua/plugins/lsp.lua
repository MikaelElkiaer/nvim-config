require("utils").create_keymap_group("<leader>c", "+code")
require("utils").create_keymap_group("<leader>y", "+yaml")

local function on_attach(_, bufnr)
  -- TODO: Re-enable after 0.11
  -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
  -- vim.keymap.set("i", "<c-space>", vim.lsp.completion.trigger, { buffer = bufnr, desc = "trigger completion" })
  -- TODO: Remove if blink.cmp is kept, otherwise uncomment
  -- vim.keymap.set("i", "<C-space>", function()
  --   return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-X><C-O>"
  -- end, { buffer = bufnr, desc = "trigger completion", expr = true })
  -- vim.keymap.set("i", "<esc>", function()
  --   return vim.fn.pumvisible() == 1 and "<C-e>" or "<esc>"
  -- end, { buffer = bufnr, desc = "cancel completion", expr = true })
  -- vim.keymap.set("i", "<cr>", function()
  --   return vim.fn.pumvisible() == 1 and "<C-y>" or "<cr>"
  -- end, { buffer = bufnr, desc = "confirm completion", expr = true })
  -- vim.keymap.set("i", "<C-k>", function()
  --   return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
  -- end, { buffer = bufnr, desc = "previous completion", expr = true })
  -- vim.keymap.set("i", "<C-j>", function()
  --   return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
  -- end, { buffer = bufnr, desc = "previous completion", expr = true })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "goto definition" })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "goto Declaration" })
  vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "goto Implementation" })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "goto references" })
  vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code action" })
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "rename" })
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
        config.on_attach = on_attach
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
        list = {
          selection = "manual",
        },
        menu = {
          auto_show = false,
        },
      },
      keymap = {
        preset = "default",
        ["<enter>"] = { "accept", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
      signature = { enabled = true },
      sources = {
        completion = {
          enabled_providers = { "lsp", "path", "buffer" },
        },
      },
    },
  },
}
