return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
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
    "aaronik/treewalker.nvim",
    keys = {
      -- movement
      { "<C-k>", "<cmd>Treewalker Up<cr>", mode = { "n", "v" } },
      { "<C-j>", "<cmd>Treewalker Down<cr>", mode = { "n", "v" } },
      { "<C-h>", "<cmd>Treewalker Left<cr>", mode = { "n", "v" } },
      { "<C-l>", "<cmd>Treewalker Right<cr>", mode = { "n", "v" } },

      -- swapping
      { "<M-k>", "<cmd>Treewalker SwapUp<cr>", mode = { "n" } },
      { "<M-j>", "<cmd>Treewalker SwapDown<cr>", mode = { "n" } },
      { "<M-h>", "<cmd>Treewalker SwapLeft<cr>", mode = { "n" } },
      { "<M-l>", "<cmd>Treewalker SwapRight<cr>", mode = { "n" } },
    },
    -- The following options are the defaults.
    -- Treewalker aims for sane defaults, so these are each individually optional,
    -- and setup() does not need to be called, so the whole opts block is optional as well.
    opts = {
      -- Whether to briefly highlight the node after jumping to it
      highlight = true,

      -- How long should above highlight last (in ms)
      highlight_duration = 250,

      -- The color of the above highlight. Must be a valid vim highlight group.
      -- (see :h highlight-group for options)
      highlight_group = "CursorLine",

      -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
      --  true: All movements more than 1 line are added to the jumplist. This is the default,
      --        and is meant to cover most use cases. It's modeled on how { and } natively add
      --        to the jumplist.
      --  false: Treewalker does not add to the jumplist at all
      --  "left": Treewalker only adds :Treewalker Left to the jumplist. This is usually the most
      --          likely one to be confusing, so it has its own mode.
      jumplist = true,
    },
  },
}
