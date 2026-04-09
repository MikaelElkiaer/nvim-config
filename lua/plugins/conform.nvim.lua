return {
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
}
