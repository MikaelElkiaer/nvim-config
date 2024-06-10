require("utils").create_keymap_group("<leader>r", "+run")

return {
  -- Create scratch buffers
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
    keys = {
      { "<leader>rn", "<cmd>Scratch<cr>", desc = "new scratch" },
      { "<leader>rN", "<cmd>ScratchWithName<cr>", desc = "new scratch (named)" },
      { "<leader>ro", "<cmd>ScratchOpen<cr>", desc = "open scratch" },
      { "<leader>rO", "<cmd>ScratchOpenFzf<cr>", desc = "open scratch (fzf)" },
    },
  },
  -- run http requests
  {
    "blackadress/rest.nvim",
    branch = "response_body_stored",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>rh", '<cmd>lua require("rest-nvim").run()<cr>', desc = "http request" },
      { "<leader>rH", '<cmd>lua require("rest-nvim").run(true)<cr>', desc = "http request (preview)" },
    },
    opts = true,
  },
  {
    "arjunmahishi/flow.nvim", -- run code from file (incl. markdown code blocks)
    cmd = { "FlowRunFile", "FlowRunMDBlock", "FlowRunSelected" },
    keys = {
      { "<leader>rR", "<cmd>FlowRunFile<cr>", desc = "run file" },
      { "<leader>rr", "<cmd>FlowRunMDBlock<cr>", desc = "run block" },
      { "<leader>rr", "<cmd>FlowRunSelected<cr>", desc = "run selected", mode = "v" },
    },
    opts = {
      filetype_cmd_map = {
        csx = "dotnet script eval <<-EOF\n%s\nEOF",
        hurl = "hurl <<-EOF\n%s\nEOF",
      },
      output = {
        buffer = true,
        split_cmd = "100vsplit",
      },
    },
  },
  {
    "MikaelElkiaer/base64.nvim",
    keys = {
      { "<leader>Bd", '<cmd>lua require("base64").decode()<cr>', desc = "base64 decode", mode = "x" },
      { "<leader>Be", '<cmd>lua require("base64").encode()<cr>', desc = "base64 encode", mode = "x" },
    },
  },
  {
    "codethread/qmk.nvim",
    enabled = false,
    opts = {
      name = "LAYOUT_split_3x6_3",
      layout = {
        "x x x x x x _ _ _ x x x x x x",
        "x x x x x x _ _ _ x x x x x x",
        "x x x x x x _ _ _ x x x x x x",
        "_ _ _ _ x x x _ x x x _ _ _ _",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = { "Oil " },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>o",
        '<cmd>lua require("oil").open()<CR>',
        desc = "Open parent directory",
      },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      {
        "<leader>rt",
        "<cmd>OverseerRun<cr>",
        desc = "Run task (Overseer)",
      },
      {
        "<leader>rT",
        "<cmd>OverseerToggle<cr>",
        desc = "Toggle task list (Overseer)",
      },
    },
    opts = {
      task_list = {
        direction = "bottom",
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
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>Cb", ":CopilotChatBuffer ", desc = "CopilotChat - Chat with current buffer" },
      { "<leader>Ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>Ct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      {
        "<leader>CT",
        "<cmd>CopilotChatVsplitToggle<cr>",
        desc = "CopilotChat - Toggle Vsplit", -- Toggle vertical split
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
