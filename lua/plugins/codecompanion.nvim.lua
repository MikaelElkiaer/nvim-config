require("utils.init"):create_keymap_group("<leader>a", "+ai")

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Action palette" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Chat" },
      { "<leader>ai", ":CodeCompanion ", desc = "Inline", mode = { "n", "v" } },
    },
    opts = {},
  },
}
