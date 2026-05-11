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
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if capabilities.textDocument and capabilities.textDocument.completion then
    capabilities.textDocument.completion.completionItem.snippetSupport = false
  end
  vim.lsp.config(server, {
    capabilities = capabilities,
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
    end, { buffer = bufnr, remap = false, desc = "Toggle codelens" })
    vim.keymap.set("n", "<leader>ch", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { buffer = bufnr, remap = false, desc = "Toggle inlay hints" })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      -- Enable built-in LSP autocompletion for this buffer
      vim.lsp.completion.enable(true, client.id, bufnr)
    end
  end,
})

-- TODO: Replace with core functionality
-- - see https://github.com/neovim/neovim/issues/38248
-- Add a rounded border to all LSP floating windows (hover, signature help)
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_open_floating_preview(contents, syntax, opts, ...)
end

local function set_popup_border(winid)
  if winid and winid >= 0 and vim.api.nvim_win_is_valid(winid) then
    pcall(vim.api.nvim_win_set_config, winid, { border = "rounded" })
  end
end

-- Case 1: item already has `info` — popup is created by C code before CompleteChanged
-- Lua callbacks fire; grab preview_winid after yielding to the event loop.
vim.api.nvim_create_autocmd("CompleteChanged", {
  group = vim.api.nvim_create_augroup("CompletionPopupBorder", { clear = true }),
  callback = function()
    vim.schedule(function()
      local info = vim.fn.complete_info({ "selected" })
      set_popup_border(info.preview_winid)
    end)
  end,
})

-- Case 2: async LSP completionItem/resolve — popup is created via nvim__complete_set
-- after a network round-trip, long after CompleteChanged has already fired.
if vim.api.nvim__complete_set then
  local orig = vim.api.nvim__complete_set
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.api.nvim__complete_set = function(index, opts)
    local windata = orig(index, opts)
    set_popup_border(windata and windata.winid)
    return windata
  end
end


