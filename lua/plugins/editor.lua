return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    keys = {
      {
        "<leader>ua",
        "<cmd>ASToggle<cr>",
        desc = "Toggle auto-save",
      },
    },
    opts = {
      condition = function(buf)
        local utils = require("auto-save.utils.data")

        return vim.fn.getbufvar(buf, "&modifiable") == 1
          and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), {})
          and not string.match(vim.fn.getcwd(), "%/nvim%-config$")
          and utils.not_in(vim.fn.expand("%:t"), {
            "picom.conf",
            "wezterm.lua",
          })
          and not string.match(vim.fn.expand("%"), "^oil://")
      end,
      execution_message = {
        message = function()
          return ""
        end,
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = "BufEnter",
    config = true,
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Todo next",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Todo prev",
      },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "todos" },
    },
  },
  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
    init = function()
      vim.g.wordmotion_prefix = "<tab>"
    end,
    keys = { "<tab>" },
  },
  {
    "echasnovski/mini.ai",
    event = "BufReadPost",
  },
  {
    "rrethy/vim-illuminate",
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    event = "BufEnter",
    opts = {
      min_count_to_highlight = 2,
    },
  },
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement",
      },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufEnter",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },
  {
    "ggandor/flit.nvim",
    dependencies = {
      "ggandor/leap.nvim",
      "tpope/vim-repeat",
    },
    keys = {
      { "f", nil, desc = "find" },
      { "F", nil, desc = "find backwards" },
      { "t", nil, desc = "till" },
      { "T", nil, desc = "till backwards" },
    },
    opts = true,
  },
  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    keys = {
      { "s", "<Plug>(leap-forward)", desc = "leap", mode = { "n", "x", "o" } },
      { "S", "<Plug>(leap-backward)", desc = "leap backward", mode = { "n", "x", "o" } },
    },
  },
  {
    "kylechui/nvim-surround",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    keys = {
      { "<C-g>sa", nil, desc = "add", mode = "i" },
      { "<C-g>sA", nil, desc = "add line", mode = "i" },
      { "gsa", nil, desc = "add", mode = "n" },
      { "gSa", nil, desc = "add cursor", mode = "n" },
      { "gsA", nil, desc = "add line", mode = "n" },
      { "gSA", nil, desc = "add", mode = "n" },
      { "gsa", nil, desc = "add", mode = "x" },
      { "gsA", nil, desc = "surround line", mode = "x" },
      { "gsd", nil, desc = "delete", mode = "n" },
      { "gsc", nil, desc = "change", mode = "n" },
      { "gsC", nil, desc = "change line", mode = "n" },
    },
    opts = {
      keymaps = {
        insert = "<C-g>sa",
        insert_line = "<C-g>sA",
        normal = "gsa",
        normal_cur = "gSa",
        normal_line = "gsA",
        normal_cur_line = "gSA",
        visual = "gsa",
        visual_line = "gsA",
        delete = "gsd",
        change = "gsc",
        change_line = "gsC",
      },
    },
  },
}
