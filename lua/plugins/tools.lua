return {
  -- Create scratch buffers
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
    init = function()
      local wk = require("which-key")
      wk.register({
        mode = { "n", "v" },
        ["<leader>S"] = { name = "+scratch" },
      })
    end,
    keys = {
      { "<leader>Sn", "<cmd>Scratch<cr>", desc = "New" },
      { "<leader>SN", "<cmd>ScratchWithName<cr>", desc = "New with name" },
      { "<leader>So", "<cmd>ScratchOpen<cr>", desc = "Open" },
      { "<leader>SO", "<cmd>ScratchOpenFzf<cr>", desc = "Open with fzf" },
    },
    opts = {
      filetypes = { "csx", "hush", "sh" }, -- filetypes to select from
    },
  },
  {
    'taybart/b64.nvim',
    cmd = { "B64Encode", "B64Decode" },
    init = function()
      local wk = require("which-key")
      wk.register({
        mode = { "n", "v" },
        ["<leader>B"] = { name = "+base64" },
      })
    end,
    keys = {
      { "<leader>Be", ':<c-u>lua require("b64").encode()<cr>', desc = "encode", mode = "v" },
      { "<leader>Bd", ':<c-u>lua require("b64").decode()<cr>', desc = "decode", mode = "v" }
    }
  },
  {
    "blackadress/rest.nvim",
    branch = "response_body_stored",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "http",
    init = function()
      local wk = require("which-key")
      wk.register({
        mode = { "n", "v" },
        ["<leader>r"] = { name = "+run" },
      })
    end,
    keys = {
      { '<leader>rh', '<cmd>lua require("rest-nvim").run()<cr>', desc = "http request" },
      { '<leader>rH', '<cmd>lua require("rest-nvim").run(true)<cr>', desc = "http request (preview)" },
    },
    opts = true,
  },
  -- run code from file (incl. markdown code blocks)
  {
    'arjunmahishi/flow.nvim',
    cmd = { "FlowRunFile", "FlowRunSelected", "RunCodeBlock" },
    init = function()
      local wk = require("which-key")
      wk.register({
        mode = { "n", "v" },
        ["<leader>r"] = { name = "+run" },
      })
    end,
    keys = {
      { '<leader>rC', '<cmd>FlowRunFile<cr>', desc = "code (file)" },
      { '<leader>rc', '<cmd>FlowRunSelected<cr>', desc = "code (selection)", mode = "v" },
      { '<leader>rc', '<cmd>RunCodeBlock<cr>', desc = "code (markdown)" },
    },
    opts = {
      output = {
        buffer = true,
        split_cmd = '100vsplit',
      },
      filetype_cmd_map = {
        sh = "bash <<-EOF\n%s\nEOF",
        csx = "dotnet script eval <<-EOF\n%s\nEOF",
      }
    },
  },
}
