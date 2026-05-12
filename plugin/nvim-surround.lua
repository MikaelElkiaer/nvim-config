vim.pack.add({
  {
    src = "https://github.com/kylechui/nvim-surround",
    version = "v4.0.5",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
})

require("nvim-surround").setup({
  aliases = {
    ["("] = ")",
    ["{"] = "}",
    ["["] = "]",
  },
  surrounds = {
    ["("] = false,
    ["{"] = false,
    ["["] = false,
  },
})

vim.keymap.set("i", "<C-g>sa", "<Plug>(nvim-surround-insert)", { desc = "add" })
vim.keymap.set("i", "<C-g>sA", "<Plug>(nvim-surround-insert-line)", { desc = "add line" })
vim.keymap.set("n", "gsa", "<Plug>(nvim-surround-normal)", { desc = "add" })
vim.keymap.set("n", "gSa", "<Plug>(nvim-surround-normal-cur)", { desc = "add cursor" })
vim.keymap.set("n", "gsA", "<Plug>(nvim-surround-normal-line)", { desc = "add line" })
vim.keymap.set("n", "gSA", "<Plug>(nvim-surround-normal-cur-line)", { desc = "add" })
vim.keymap.set("x", "gsa", "<Plug>(nvim-surround-visual)", { desc = "add" })
vim.keymap.set("x", "gsA", "<Plug>(nvim-surround-visual-line)", { desc = "surround line" })
vim.keymap.set("n", "gsd", "<Plug>(nvim-surround-delete)", { desc = "delete" })
vim.keymap.set("n", "gsc", "<Plug>(nvim-surround-change)", { desc = "change" })
vim.keymap.set("n", "gsC", "<Plug>(nvim-surround-change-line)", { desc = "change line" })
