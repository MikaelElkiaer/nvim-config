return {
  {
    "XXiaoA/auto-save.nvim",
    event = "BufReadPre",
    opts = {
      condition = function(buf)
        local utils = require("auto-save.utils.data")

        return vim.fn.getbufvar(buf, "&modifiable") == 1
            and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), {})
            and not string.match(vim.fn.getcwd(), "%/nvim%-basic%-ide$")
            and utils.not_in(vim.fn.expand("%:t"), {
              "picom.conf",
              "wezterm.lua"
            })
      end,
      execution_message = {
        message = function() return "" end
      }
    },
  },
  -- Extended dial capabilities
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
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
  -- camel/pascal/snake/kebab case motions
  {
    "chaoren/vim-wordmotion",
    init = function()
      vim.g.wordmotion_prefix = "<BS>"
    end,
    keys = { "<BS>" },
  },
  -- More text objects, for quicker manipulation
  {
    "wellle/targets.vim",
    event = "BufReadPost"
  },
  -- simple and powerful search-based navigation
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').add_default_mappings()
    end,
    dependencies = { { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } } },
    event = "VeryLazy",
    keys = { "s", "S" }
  },
  -- automatic cwd based on current buffer
  {
    'airblade/vim-rooter',
    event = "VeryLazy",
    init = function()
      vim.g.rooter_cd_cmd = 'lcd'
    end,
  },
  {
    "cuducos/yaml.nvim",
    cmd = "YAMLYank",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim"
    },
    keys = {
      { "<leader>y", "<cmd>YAMLYank<cr>", desc = "yank yaml key/value" }
    }
  },
  -- markdown browser preview and sync
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    cmd = "MarkdownPreview",
  },
}
