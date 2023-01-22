return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function(_, opts)
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
          on_output = helpers.diagnostics.from_pattern(
            "^(.*): .* %(line (%d+), column (%d+)%) %- (.*)$",
            { "severity", "row", "col", "message" },
            { severities = { ["Error"] = 1 } }
          ),
        },
        factory = helpers.generator_factory,
      })

      local more_opts = {
        sources = {
          diagnostics_hush,
        },
      }
      vim.tbl_deep_extend("force", opts, more_opts)
    end,
    dependencies = {
      {
        "jayp0521/mason-null-ls.nvim",
        opts = { automatic_installation = true },
      },
    },
    event = "BufReadPre",
    requires = { "neovim/nvim-lspconfig" },
  },
}
