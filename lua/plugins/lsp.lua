require("utils").create_keymap_group("<leader>c", "+code")
require("utils").create_keymap_group("<leader>y", "+yaml")

local function on_attach(_, bufnr)
  -- TODO: Re-enable after 0.11
  -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
  -- vim.keymap.set("i", "<c-space>", vim.lsp.completion.trigger, { buffer = bufnr, desc = "trigger completion" })
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
    config = function(_, _)
      local lspconfig = require("lspconfig")
      lspconfig.bashls.setup({
        on_attach = on_attach,
      })
      lspconfig.dockerls.setup({
        on_attach = on_attach,
      })
      lspconfig.gopls.setup({
        on_attach = on_attach,
      })
      lspconfig.helm_ls.setup({
        on_attach = on_attach,
      })
      lspconfig.jsonls.setup({
        on_attach = on_attach,
      })
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      lspconfig.marksman.setup({
        on_attach = on_attach,
      })
      lspconfig.nil_ls.setup({
        on_attach = on_attach,
      })
      lspconfig.yamlls.setup(require("yaml-companion").setup({
        on_attach = on_attach,
      }))
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
    },
    event = "BufEnter",
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "LSP Info" },
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
}
