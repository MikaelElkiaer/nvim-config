vim.pack.add({
  {
    src = "https://github.com/stevearc/conform.nvim",
    version = "master",
  },
})

-- init
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("conform").setup({
  formatters_by_ft = {
    cs = { "csharpier" },
    go = { "gofmt" },
    html = { "html_beautify" },
    javascript = { "prettierd" },
    jsonc = { "jq" },
    jsonnet = { "jsonnetfmt" },
    lua = { "stylua" },
    markdown = { "markdownlint-cli2" },
    nix = { "nixfmt" },
    sh = { "shfmt" },
    toml = { "taplo" },
    yaml = { "yq" },
    xml = { "xmlformat" },
  },
})

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  require("conform").format()
end, { desc = "format" })
