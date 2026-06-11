vim.pack.add({
  {
    src = "https://github.com/zbirenbaum/copilot.lua",
    version = "v3.0.0",
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
require("copilot.command").disable()
require("copilot-eldritch").setup()

-- Keymaps
vim.keymap.set("n", "<leader>uC", "<cmd>Copilot toggle<cr>", { desc = "Toggle Copilot" })
vim.keymap.set("i", "<M-h>", function()
  require("copilot.command").enable()
  _ = require("copilot.suggestion").next()
end, { desc = "Select next Copilot suggestion" })
vim.keymap.set("i", "<M-j>", function()
  require("copilot.command").enable()
  _ = require("copilot.suggestion").accept_word()
end, { desc = "Accept Copilot suggestion - word only" })
vim.keymap.set("i", "<M-k>", function()
  require("copilot.command").enable()
  _ = require("copilot.suggestion").prev()
end, { desc = "Select previous Copilot suggestion" })
vim.keymap.set("i", "<M-l>", function()
  require("copilot.command").enable()
  _ = require("copilot.suggestion").accept_line()
end, { desc = "Accept Copilot suggestion - line only" })
