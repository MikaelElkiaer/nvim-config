return {
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
    keys = {
      { "<leader>sn", "<cmd>Scratch<cr>", desc = "New" },
      { "<leader>sN", "<cmd>ScratchWithName<cr>", desc = "New with name" },
      { "<leader>so", "<cmd>ScratchOpen<cr>", desc = "Open" },
      { "<leader>sO", "<cmd>ScratchOpenFzf<cr>", desc = "Open with fzf" },
    },
    opts = {
      filetypes = { "csx", "hush", "sh" }, -- filetypes to select from
    },
  },
  {
    'taybart/b64.nvim',
    cmd = { "B64Encode", "B64Decode" }
  },
  {
    "blackadress/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    branch = "response_body_stored",
    ft = "http",
    keys = {
      { '<leader>rh', '<cmd>lua require("rest-nvim").run()<cr>', desc = "http request" },
      { '<leader>rH', '<cmd>lua require("rest-nvim").run(true)<cr>', desc = "http request (preview)" },
    },
    opts = true,
  },
  -- run code from file (incl. markdown code blocks)
  {
    'arjunmahishi/flow.nvim',
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
    cmd = { "FlowRunFile", "FlowRunSelected" },
    keys = {
      { '<leader>rc', '<cmd>FlowRunFile<cr>', desc = "code file" },
      { '<leader>rc', '<cmd>FlowRunSelected<cr>', desc = "code selection", mode = "v" },
    }
  },
}
