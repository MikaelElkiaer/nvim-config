local function on_attach(_, bufnr)
  -- TODO: Re-enable after 0.11
  -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
  -- vim.keymap.set("i", "<c-space>", vim.lsp.completion.trigger, { buffer = bufnr, desc = "trigger completion" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "goto definition" })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "goto Declaration" })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code action" })
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
        lua = { "stylua" },
        markdown = { "mdformat" },
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
      vim.tbl_extend("force", lint.linters, {
        hush = {
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
        },
      })
      vim.tbl_extend("force", lint.linters_by_ft, {
        hush = { "hush" },
      })
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
      lspconfig.omnisharp.setup({
        filetypes = { "cs", "csx" },
        handlers = {
          ["textDocument/definition"] = require("omnisharp_extended").handler,
        },
        on_attach = function(_, bufnr)
          on_attach(_, bufnr)
          -- Use omnisharp_extended for decompilation
          vim.keymap.set(
            "n",
            "gd",
            require("omnisharp_extended").telescope_lsp_definitions,
            { buffer = bufnr, desc = "goto definition" }
          )
        end,
        root_dir = function(fname)
          if fname:sub(-#".csx") == ".csx" then
            return require("lspconfig").util.path.dirname(fname)
          end
          local root = require("lspconfig.util").root_pattern("*.sln")(fname)
          return root or vim.fn.getcwd()
        end,
      })
      lspconfig.yamlls.setup(require("yaml-companion").setup({
        on_attach = on_attach,
      }))
    end,
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim",
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
