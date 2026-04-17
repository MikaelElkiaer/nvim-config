vim.pack.add({
  {
    src = "https://github.com/eandrju/cellular-automaton.nvim",
    version = "main",
  },
})

require("cellular-automaton")
vim.keymap.set("n", "<leader>F", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "FML" })
