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
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },
  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
    init = function()
      vim.g.wordmotion_prefix = "<bs>"
    end,
    keys = { "<bs>" },
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
}
