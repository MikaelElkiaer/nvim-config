vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent decrease" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent increase" })

vim.keymap.set("n", "<leader>m", ":Man ", { desc = "Open manpage" })

vim.keymap.set("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev()
  vim.diagnostic.open_float({ focus = false, scope = "cursor" })
end, { desc = "Go to previous diagnostic and display" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next()
  vim.diagnostic.open_float({ focus = false, scope = "cursor" })
end, { desc = "Go to next diagnostic and display" })

local blink_ok, _ = pcall(require, "blink.cmp")
if not blink_ok then
  vim.keymap.set("i", "<C-space>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-X><C-O>"
  end, { desc = "trigger completion", expr = true })
  vim.keymap.set("i", "<esc>", function()
    return vim.fn.pumvisible() == 1 and "<C-e><esc>" or "<esc>"
  end, { desc = "cancel completion", expr = true })
  vim.keymap.set("i", "<cr>", function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or "<cr>"
  end, { desc = "confirm completion", expr = true })
  vim.keymap.set("i", "<C-k>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
  end, { desc = "previous completion", expr = true })
  vim.keymap.set("i", "<C-j>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
  end, { desc = "previous completion", expr = true })
end

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank - clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>Y", '"+Y', { desc = "Yank - clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste - clipboard" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste - clipboard" })

vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

vim.keymap.set("n", "vn", function()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if not node then
    return
  end
  local start_row, start_col, end_row, end_col = node:range()
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })
end, { desc = "Select current Treesitter node" })
