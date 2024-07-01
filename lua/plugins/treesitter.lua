return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    event = { "BufEnter", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    main = "nvim-treesitter.configs", -- setup must be called on this module
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufEnter",
    opts = { mode = "cursor", max_lines = 3 },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
  {
    "ziontee113/syntax-tree-surfer",
    cmd = { "STSSelectMasterNode", "STSSelectCurrentNode" },
    keys = {
      -- Normal Mode Swapping:
      -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
      {
        "vU",
        function()
          vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
          return "g@l"
        end,
        desc = "Swap prev - master",
        expr = true,
      },
      {
        "vD",
        function()
          vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
          return "g@l"
        end,
        desc = "Swap next - master",
        expr = true,
      },
      -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
      {
        "vd",
        function()
          vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
          return "g@l"
        end,
        desc = "Swap next - current",
        expr = true,
      },
      {
        "vu",
        function()
          vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
          return "g@l"
        end,
        desc = "Swap prev - current",
        expr = true,
      },
      -- Visual Selection from Normal Mode
      { "vx", "<cmd>STSSelectMasterNode<cr>", desc = "Select - master" },
      { "vn", "<cmd>STSSelectCurrentNode<cr>", desc = "Select - current" },
      -- Select Nodes in Visual Mode
      { "J", "<cmd>STSSelectNextSiblingNode<cr>", mode = "x", desc = "Select - next" },
      { "K", "<cmd>STSSelectPrevSiblingNode<cr>", mode = "x", desc = "Select - prev" },
      { "H", "<cmd>STSSelectParentNode<cr>", mode = "x", desc = "Select - parent" },
      { "L", "<cmd>STSSelectChildNode<cr>", mode = "x", desc = "Select - child" },
      -- Swapping Nodes in Visual Mode
      { "<A-j>", "<cmd>STSSwapNextVisual<cr>", mode = "x", desc = "Swap next" },
      { "<A-k>", "<cmd>STSSwapPrevVisual<cr>", mode = "x", desc = "Swap prev" },
    },
    opts = true,
  },
}
