local function on_attach(_, bufnr)
  -- TODO: Re-enable after 0.11
  -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
  -- vim.keymap.set("i", "<c-space>", vim.lsp.completion.trigger, { buffer = bufnr, desc = "trigger completion" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "goto definition" })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "goto Declaration" })
end

return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    dependencies = {
      "mason.nvim",
    },
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
      local configs = require("lspconfig.configs")
      -- if not configs.helm_ls then
      --   configs.helm_ls = {
      --     default_config = {
      --       cmd = { "helm_ls", "serve" },
      --     },
      --   }
      -- end
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
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_installation = true,
    },
  },
}
