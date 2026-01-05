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
    opts = {
      ---@type CodeCompanion.AdapterArgs
      adapters = {
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "oauth-personal",
                ---@type string
                oauth_credentials_path = vim.fs.abspath("~/.gemini/oauth_creds.json"),
              },
              handlers = {
                auth = function(self)
                  ---@type string|nil
                  local oauth_credentials_path = self.defaults.oauth_credentials_path
                  return (oauth_credentials_path and vim.fn.filereadable(oauth_credentials_path)) == 1
                end,
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
        cmd = {
          adapter = "copilot",
        },
      },
    },
  },
}
