return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["z"] = { name = "+fold" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gr"] = { name = "+lsp" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
  {
    "echasnovski/mini.misc",
    event = "VimEnter",
    init = function()
      local mini = require("mini.misc")
      mini.setup_auto_root()
      mini.setup_restore_cursor()
    end,
    opts = true,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      vim.notify = require("notify")
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = true,
  },
  {
    "nvimdev/dashboard-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VimEnter",
    opts = {
      config = {
        project = {
          action = function(_)
            require("persistence").load()
          end,
        },
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = true,
  },
}
