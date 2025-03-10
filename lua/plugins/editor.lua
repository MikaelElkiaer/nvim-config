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
    opts = function(_, opts)
      local group = vim.api.nvim_create_augroup("autosave", {})
      vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveEnable",
        group = group,
        callback = function(_)
          vim.notify("AutoSave enabled", vim.log.levels.INFO)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveDisable",
        group = group,
        callback = function(_)
          vim.notify("AutoSave disabled", vim.log.levels.INFO)
        end,
      })
      return vim.tbl_extend("force", opts, {
        condition = function(buf)
          return vim.fn.getbufvar(buf, "&modifiable") == 1
            -- Nvim config
            and not string.match(vim.fn.getcwd(), "%/nvim%-config$")
            -- Auto-reloading config files
            and not vim.list_contains({ "alacritty.toml", "picom.conf", "wezterm.lua" }, vim.fn.expand("%:t"))
            -- Oil buffers
            and not string.match(vim.fn.expand("%"), "^oil://")
            -- Live editing of kubernetes resources
            and not string.match(vim.fn.expand("%"), "/tmp/kubectl-edit-.*%.yaml")
            -- Octo buffers
            and not string.match(vim.fn.expand("%"), "^octo://")
            -- Gitcommit
            and not (vim.bo.filetype == "gitcommit")
        end,
      })
    end,
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
          require("todo-comments").jump_next({ keywords = { "TODO" } })
        end,
        desc = "Todo next",
      },
      {
        "]T",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Todo next - all",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev({ keywords = { "TODO" } })
        end,
        desc = "Todo prev",
      },
      {
        "[T",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Todo prev - all",
      },
      { "<leader>ft", "<cmd>TodoTelescope keywords=TODO<cr>", desc = "todos" },
      { "<leader>fT", "<cmd>TodoTelescope<cr>", desc = "todos - all" },
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
      filetypes_denylist = {
        "oil",
      },
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufEnter",
    opts = {
      scope = {
        include = {
          node_type = { lua = { "table_constructor" } },
        },
        show_start = false,
        show_end = false,
      },
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
      aliases = {
        ["("] = ")",
        ["{"] = "}",
        ["["] = "]",
      },
      surrounds = {
        ["("] = false,
        ["{"] = false,
        ["["] = false,
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    cmd = { "RenderMarkdown" },
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render Markdown" },
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
    },
  },
}
