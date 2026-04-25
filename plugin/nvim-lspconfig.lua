vim.pack.add({
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    version = "master",
  },
})

local servers = {
  "bashls",
  "dockerls",
  "gopls",
  "helm_ls",
  "jsonls",
  "jsonnet_ls",
  "lua_ls",
  "marksman",
  "nil_ls",
  "pylsp",
  "terraform_lsp",
  "ts_ls",
  "yamlls",
}

for _, server in pairs(servers) do
  vim.lsp.config(server, {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  })
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf

    vim.keymap.set("n", "<leader>ci", "<cmd>LspInfo<cr>", { buffer = bufnr, remap = false, desc = "LSP Info" })
    vim.keymap.set("n", "<leader>cc", function()
      vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
    end, { buffer = bufnr, remap = false, desc = "Toggle inlay hints" })
    vim.keymap.set("n", "<leader>ch", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { buffer = bufnr, remap = false, desc = "Toggle inlay hints" })
  end,
})
