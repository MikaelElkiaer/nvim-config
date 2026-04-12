vim.pack.add({ "https://github.com/eandrju/cellular-automaton.nvim" })

require("cellular-automaton")
vim.keymap.set("n", "<leader>F", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "FML" })
