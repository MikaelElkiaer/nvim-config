vim.pack.add({
  {
    src = "https://www.github.com/nvim-lua/plenary.nvim",
    version = "master",
  },
})
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
})
vim.pack.add({
  {
    src = "https://www.github.com/olimorris/codecompanion.nvim",
    version = "v19.10.0",
  },
})

require("codecompanion").setup({
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
})

vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "Action palette" })
vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Chat" })
vim.keymap.set({ "n", "v" }, "<leader>ai", ":CodeCompanion ", { desc = "Inline" })
