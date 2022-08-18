local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
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
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
  keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
  keymap(bufnr, "n", "<leader>lD", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

  vim.keymap.set("n", "<leader>ll", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
  vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<CR>", { silent = true })
  vim.keymap.set("v", "<leader>la", "<cmd><C-U>Lspsaga range_code_action<CR>", { silent = true })
  vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
  vim.keymap.set("n", "<leader>ls", "<Cmd>Lspsaga signature_help<CR>", { silent = true })
  vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { silent = true })
  vim.keymap.set("n", "<leader>lp", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
  vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
  vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
  vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
  end

  if client.name == "sumneko_lua" then
    client.server_capabilities.document_formatting = false
  end

  lsp_keymaps(bufnr)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client)
end

return M
