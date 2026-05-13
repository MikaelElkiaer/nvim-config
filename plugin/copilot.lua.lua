vim.pack.add({
  {
    src = "https://github.com/zbirenbaum/copilot.lua",
    version = "v2.0.3",
  },
  {
    src = "https://github.com/samiulsami/copilot-eldritch.nvim",
    version = "master",
  },
})

require("copilot").setup({
  filetypes = {
    markdown = true,
    yaml = true,
  },
  suggestion = {
    auto_trigger = true,
    enabled = true,
  },
})
require("copilot-eldritch").setup()

vim.keymap.set("n", "<leader>uC", "<cmd>Copilot toggle<cr>", { desc = "Toggle Copilot" })
vim.keymap.set("i", "<M-h>", function()
  _ = require("copilot.suggestion").next()
end, { desc = "Select next Copilot suggestion" })
vim.keymap.set("i", "<M-j>", function()
  _ = require("copilot.suggestion").accept_word()
end, { desc = "Accept Copilot suggestion - word only" })
vim.keymap.set("i", "<M-k>", function()
  _ = require("copilot.suggestion").prev()
end, { desc = "Select previous Copilot suggestion" })
