return {
  {
    "zbirenbaum/copilot.lua",
    keys = {
      {
        "<leader>uC",
        "<cmd>Copilot toggle<cr>",
        desc = "Toggle Copilot",
      },
      {
        "<M-h>",
        function()
          _ = require("copilot.suggestion").next()
        end,
        desc = "Select next Copilot suggestion",
        mode = "i",
      },
      {
        "<M-j>",
        function()
          _ = require("copilot.suggestion").accept_word()
        end,
        desc = "Accept Copilot suggestion - word only",
        mode = "i",
      },
      {
        "<M-k>",
        function()
          _ = require("copilot.suggestion").prev()
        end,
        desc = "Select previous Copilot suggestion",
        mode = "i",
      },
    },
    opts = {
      filetypes = {
        markdown = true,
        yaml = true,
      },
      suggestion = {
        auto_trigger = true,
        enabled = true,
      },
    },
  },
}
