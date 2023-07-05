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
    opts = {
      filetypes = { "bash", "csx", "hush" },
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
    config = {
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>o",
        '<cmd>lua require("oil").open()<CR>',
        desc = "Open parent directory",
      },
    },
  },
}
