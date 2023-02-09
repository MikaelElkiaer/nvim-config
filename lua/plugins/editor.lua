return {
  {
    "XXiaoA/auto-save.nvim",
    event = "BufReadPre",
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
      end,
      execution_message = {
        message = function()
          return ""
        end,
      },
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
    "chaoren/vim-wordmotion",
    init = function()
      vim.g.wordmotion_prefix = "<BS>"
    end,
    keys = { "<BS>" },
  },
  {
    "wellle/targets.vim",
    event = "BufReadPost",
  },
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_cd_cmd = "lcd"
    end,
    lazy = false,
  },
  {
    "rmagatti/auto-session",
    event = "VimEnter",
    opts = {
      log_level = "error",
      cwd_change_handling = {
        restore_upcoming_session = true,
      },
      auto_session_suppress_dirs = {
        "/home/*",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    config = function(_, opts)
      local nvim_autopairs = require("nvim-autopairs")
      nvim_autopairs.setup(opts)

      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    opts = {
      check_ts = true,
    },
  },
  {
    "kylechui/nvim-surround",
    opts = {
      keymaps = {
        insert = nil,
        insert_line = nil,
        normal = "gzs",
        normal_cur = "gzss",
        normal_line = "gzS",
        normal_cur_line = "gzSS",
        visual = "gzs",
        visual_line = "gzS",
        delete = "gzd",
        change = "gzc",
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    keys = {
      {
        "<C-n>",
        function()
          _ = require("luasnip").choice_active() and require("luasnip.extras.select_choice")()
        end,
        mode = { "i", "s" },
      },
    },
  },
}
