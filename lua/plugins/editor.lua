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
    event = "VeryLazy",
    init = function()
      vim.g.rooter_cd_cmd = "lcd"
    end,
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
}
