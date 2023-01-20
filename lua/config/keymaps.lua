-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Navigate buffers
vim.keymap.set("n", "gk", ":bnext<CR>", { desc = "next buffer", silent = true })
vim.keymap.set("n", "gj", ":bprevious<CR>", { desc = "prev buffer", silent = true })

-- Navigate tabs
vim.keymap.set("n", "gh", ":tabnext<CR>", { desc = "next tab", silent = true })
vim.keymap.set("n", "gl", ":tabprevious<CR>", { desc = "prev tab", silent = true })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "clear hlsearch", silent = true })

-- Better paste
vim.keymap.set("v", "p", '"_dP', { desc = "better paste", silent = true })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "indent left", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "indent right", silent = true })
