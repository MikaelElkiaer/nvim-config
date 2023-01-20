return {
  -- for formatters and linters
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "Hoffs/omnisharp-extended-lsp.nvim",
    },
    ---@class PluginLspOpts
    opts = function(_, opts)
      return {
        -- options for vim.diagnostic.config()
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = { spacing = 4, prefix = "●" },
          severity_sort = true,
        },
        -- Automatically format on save
        autoformat = true,
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overriden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        ---@type lspconfig.options
        servers = {
          cssls = {},
          html = {},
          tsserver = {},
          pyright = {
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "off",
                },
              },
            },
          },
          bashls = {},
          helm_ls = {
            cmd = { "helm_ls", "serve" },
            filetypes = { 'helm' },
          },
          yamlls = {},
          omnisharp = {
            filetypes = { "cs", "csx" },
            handlers = {
              ["textDocument/definition"] = require('omnisharp_extended').handler,
            },
            root_dir = function(fname)
              if fname:sub(- #".csx") == ".csx" then
                return require('lspconfig').util.path.dirname(fname)
              end
              return vim.fn.getcwd()
            end
          },
          dockerls = {},
          terraformls = {},
          gopls = {},
          jsonls = {},
          sumneko_lua = {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                  },
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
    end,
    ---@param opts PluginLspOpts
    config = function(plugin, opts)
      local configs = require('lspconfig.configs')
      if not configs.helm_ls then
        configs.helm_ls = {
          default_config = {
            cmd = { "helm_ls", "serve" },
            filetypes = { 'helm' },
            root_dir = function(fname)
              local util = require('lspconfig.util')
              return util.root_pattern('Chart.yaml')(fname)
            end,
          },
        }
      end

      -- setup formatting and keymaps
      local on_attach = function(client, bufnr)
        if client.name == "tsserver" then
          client.server_capabilities.document_formatting = false
        end

        if client.name == "sumneko_lua" then
          client.server_capabilities.document_formatting = false
        end

        if client.name == "yamlls" then
          local ft = vim.bo[bufnr].filetype
          if ft == "" or ft == "helm" then
            client.stop()
          end
        end

        local keymap_opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", keymap_opts)
        keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", keymap_opts)
        keymap(bufnr, "n", "gI", "<cmd>Telescope lsp_implementations<CR>", keymap_opts)
        keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", keymap_opts)
        keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format { async = true }<cr>", keymap_opts)
        keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", keymap_opts)
        keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", keymap_opts)
        keymap(bufnr, "n", "<leader>lD", "<cmd>lua vim.diagnostic.setloclist()<CR>", keymap_opts)

        vim.keymap.set("n", "<leader>ll", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
        vim.keymap.set({ "v", "n" }, "<leader>la", "<cmd>Lspsaga code_action<CR>", { silent = true })
        vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
        vim.keymap.set("n", "<leader>ls", "<Cmd>Lspsaga signature_help<CR>", { silent = true })
        vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { silent = true })
        vim.keymap.set("n", "<leader>lp", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
        vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
        vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
        vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
        vim.keymap.set("n", "<leader>lo", "<cmd>LSoutlineToggle<CR>", { silent = true })

        local illuminate_ok, illuminate = pcall(require, "illuminate")
        if illuminate_ok then
          illuminate.on_attach(client)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          on_attach(client, buffer)
        end,
      })

      local signs = {

        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      local config = {
        virtual_text = true,
        signs = {
          active = signs, -- show signs
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }

      vim.diagnostic.config(config)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      local servers = opts.servers

      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

      local setup_server = function(server)
        local server_opts = servers[server] or {}
        server_opts.capabilities = capabilities
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end
      require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
      require("mason-lspconfig").setup_handlers({
        setup_server,
      })
      setup_server("helm_ls")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local helpers = require("null-ls.helpers")
      local methods = require("null-ls.methods")

      local diagnostics_hush = helpers.make_builtin({
        name = "hush",
        meta = {
          url = "https://github.com/hush-shell/hush",
          description = "Using hush to do static checking",
        },
        method = methods.internal.DIAGNOSTICS,
        filetypes = { "hush" },
        generator_opts = {
          command = "hush",
          args = { "--check" },
          to_stdin = true,
          from_stderr = true,
          format = "line",
          check_exit_code = function(code)
            return code <= 1
          end,
          -- Example:
          -- Error: <stdin> (line 3, column 0) - undeclared variable 'et'
          on_output = helpers.diagnostics.from_pattern('^(.*): .* %(line (%d+), column (%d+)%) %- (.*)$',
            { "severity", "row", "col", "message" }, { severities = { ["Error"] = 1 } })
        },
        factory = helpers.generator_factory,
      })

      null_ls.setup({
        debug = false,
        sources = {
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.formatting.markdownlint,
          null_ls.builtins.diagnostics.shellcheck,
          diagnostics_hush,
        },
      })
    end,
    event = "BufReadPre",
    requires = { "neovim/nvim-lspconfig" },
  },
  {
    "jayp0521/mason-null-ls.nvim",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim"
    },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>M", "<cmd>Mason<cr>", desc = "mason ui" }
    },
    opts = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", },
    event = "BufReadPre",
  },
  -- lsp UI enhancements
  {
    "glepnir/lspsaga.nvim",
    event = "BufReadPre",
    opts = {
      code_action_lightbulb = {
        sign = false,
        enable_in_insert = false,
      },
      symbol_in_winbar = {
        enable = true
      }
    },
  },
  -- Go to definition for external symbols
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    { "towolf/vim-helm", ft = "helm" },
  },
}
