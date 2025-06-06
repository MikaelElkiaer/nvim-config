require("utils.init"):create_keymap_group("<leader>C", "+copilot")

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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
      debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
      disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
      language = "English", -- Copilot answer language settings when using default prompts. Default language is English.
      -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
      -- temperature = 0.1,
    },
    branch = "main",
    build = "make tiktoken",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    keys = {
      { "<leader>Cb", ":CopilotChat ", desc = "CopilotChat - Chat with current buffer" },
      { "<leader>Ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>Ct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      {
        "<leader>CT",
        "<cmd>CopilotChatToggle<cr>",
        desc = "CopilotChat - Toggle",
      },
      {
        "<leader>Cv",
        ":CopilotChatVisual ",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>Cx",
        ":CopilotChatInPlace<cr>",
        mode = "x",
        desc = "CopilotChat - Run in-place code",
      },
      {
        "<leader>Cf",
        "<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
        desc = "CopilotChat - Fix diagnostic",
      },
      {
        "<leader>Cr",
        "<cmd>CopilotChatReset<cr>", -- Reset chat history and clear buffer.
        desc = "CopilotChat - Reset chat history and clear buffer",
      },
    },
  },
}
