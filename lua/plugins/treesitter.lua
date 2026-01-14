return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
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
    cmd = "Treewalker",
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

      -- Whether to create a visual selection after a movement to a node.
      -- If true, highlight is disabled and a visual selection is made in
      -- its place.
      select = false,

      -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
      --  true: All movements more than 1 line are added to the jumplist. This is the default,
      --        and is meant to cover most use cases. It's modeled on how { and } natively add
      --        to the jumplist.
      --  false: Treewalker does not add to the jumplist at all
      --  "left": Treewalker only adds :Treewalker Left to the jumplist. This is usually the most
      --          likely one to be confusing, so it has its own mode.
      jumplist = true,

      -- Whether movement, when inside the scope of some node, should be confined to that scope.
      -- When true, when moving through neighboring nodes inside some node, you won't be able to
      -- move outside of that scope via :Treewalker Up/Down. When false, if on a node at the end
      -- of a scope, movement will bring you to the next node of similar indentation/number of
      -- ancestor nodes, even when it is outside of the scope you're currently in.
      scope_confined = false,
    },
  },
  {
    "MeanderingProgrammer/treesitter-modules.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    ---@module 'treesitter-modules'
    ---@type ts.mod.UserConfig
    opts = {
      -- automatically install missing parsers when entering buffer
      auto_install = true,
      fold = {
        enable = true,
      },
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        -- set value to `false` to disable individual mapping
        -- node_decremental captures both node_incremental and scope_incremental
        keymaps = {
          init_selection = "vn",
          node_incremental = "<c-h>",
          scope_incremental = "<c-k>",
          node_decremental = "<c-l>",
        },
      },
      indent = {
        enable = true,
      },
    },
  },
}
