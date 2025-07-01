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
    opts = {
      signs = false,
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
    ft = { "markdown", "codecompanion" },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render Markdown" },
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
      file_types = { "markdown", "codecompanion" },
    },
  },
  {
    "saghen/blink.cmp",

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-j>"] = { "select_next", "fallback_to_mappings" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = { auto_show = false },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        trigger = { show_on_keyword = false, show_on_trigger_character = false },
      },

      signature = { enabled = true, trigger = { enabled = true } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "buffer" },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
