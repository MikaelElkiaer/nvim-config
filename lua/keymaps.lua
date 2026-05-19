vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent decrease" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent increase" })

vim.keymap.set("n", "<leader>M", ":Man ", { desc = "Open manpage" })

vim.keymap.set("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic and display" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic and display" })

vim.keymap.set("i", "<C-e>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-X><C-O>"
end, { desc = "trigger completion", expr = true })
vim.keymap.set("i", "<esc>", function()
  return vim.fn.pumvisible() == 1 and "<C-e><esc>" or "<esc>"
end, { desc = "cancel completion", expr = true })
vim.keymap.set("i", "<c-y>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<cr>"
end, { desc = "confirm completion", expr = true })
vim.keymap.set("i", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { desc = "previous completion", expr = true })
vim.keymap.set("i", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { desc = "previous completion", expr = true })

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank - clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>Y", '"+Y', { desc = "Yank - clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste - clipboard" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste - clipboard" })

vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

vim.keymap.set("n", "<leader>s", ":w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>S", ":wa<cr>", { desc = "Save all files" })

vim.keymap.set("n", "<leader>U", "<cmd>packadd nvim.undotree<cr><cmd>Undotree<cr>", { desc = "Undo tree" })

vim.keymap.set("n", "grd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })

-- Global table to store the state for the dot-repeat operator
_G.conflict_resolver_state = { side = nil }

-- The core resolution execution
local function run_resolution()
  local side = _G.conflict_resolver_state.side
  if not side then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]

  -- 'bWnc' = Backwards, Without moving cursor, return line Number, accept match at Cursor
  -- 'Wnc'  = Forwards, Without moving cursor, return line Number, accept match at Cursor
  local start_line = vim.fn.search("^<<<<<<<", "bWnc")
  local middle_line = vim.fn.search("^=======", "bWnc")
  local end_line = vim.fn.search("^>>>>>>>", "Wnc")

  -- If the middle marker is behind the start marker, scan forward instead (with 'c' flag)
  if middle_line < start_line then
    middle_line = vim.fn.search("^=======", "Wnc")
  end

  -- Validate that the cursor is trapped inside this specific conflict block boundaries
  if start_line == 0 or end_line == 0 or middle_line == 0 or cursor_row < start_line or cursor_row > end_line then
    print("Cursor is not inside a valid conflict block.")
    return
  end

  -- Extract and replace lines atomically
  if side == "ours" then
    local lines_to_keep = vim.api.nvim_buf_get_lines(bufnr, start_line, middle_line - 1, false)
    vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, lines_to_keep)
    print("Resolved: Kept Ours")
  elseif side == "theirs" then
    local lines_to_keep = vim.api.nvim_buf_get_lines(bufnr, middle_line, end_line - 1, false)
    vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, lines_to_keep)
    print("Resolved: Kept Theirs")
  end
end

-- Wrapper function that registers itself to Neovim's operatorfunc
local function setup_repeatable_resolve(side)
  _G.conflict_resolver_state.side = side

  _G.ConflictResolveOperator = function()
    run_resolution()
  end

  vim.o.operatorfunc = "v:lua.ConflictResolveOperator"
  return "g@l"
end

-- Keymaps
vim.keymap.set("n", "<leader>gco", function()
  return setup_repeatable_resolve("ours")
end, { expr = true, desc = "Conflict: Keep Ours (Repeatable)" })

vim.keymap.set("n", "<leader>gct", function()
  return setup_repeatable_resolve("theirs")
end, { expr = true, desc = "Conflict: Keep Theirs (Repeatable)" })
