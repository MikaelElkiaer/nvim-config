return {
  { "folke/lazy.nvim", version = false },
  {
    "nvim-lua/plenary.nvim", -- Useful utils
  },
  {
    "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
    requires = { "nvim-cmp" },
    config = function()
      require "user.autopairs"
    end
  },
  { "numToStr/Comment.nvim",
    config = function()
      require "user.comment"
    end
  }
  , { "JoosepAlviste/nvim-ts-context-commentstring",
    requires = { "nvim-treesitter" },
  }
  , { "kyazdani42/nvim-web-devicons", }
  , { "akinsho/bufferline.nvim",
    config = function()
      require "user.bufferline"
    end
  }
  , { "moll/vim-bbye" }
  , { "nvim-lualine/lualine.nvim",
    config = function()
      require "user.lualine"
    end
  }
  , { "akinsho/toggleterm.nvim",
    config = function()
      require "user.toggleterm"
    end,
  }
  , { "lewis6991/impatient.nvim",
    config = function()
      require "user.impatient"
    end,
  }
  , { "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "user.indentline"
    end,
    event = "BufReadPre",
  }

  -- Colorschemes
  , {
    "ellisonleao/gruvbox.nvim",
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")
    end,
    lazy = false,
    opts = {
      bold = false,
      italic = false,
      contrast = "hard",
      invert_tabline = true,
    },
  }

  -- cmp plugins
  , { "hrsh7th/nvim-cmp", -- The completion plugin
    requires = { "friendly-snippets" },
    config = function()
      require "user.cmp"
    end,
  }
  , { "hrsh7th/cmp-buffer",
    requires = { "cmp-nvim-lsp" }
  }
  , { "hrsh7th/cmp-path",
    requires = { "cmp-buffer" }
  }
  , { "saadparwaiz1/cmp_luasnip",
    requires = { "LuaSnip" }
  }
  , { "hrsh7th/cmp-nvim-lsp",
    requires = { "cmp-nvim-lua" }
  }
  , { "hrsh7th/cmp-nvim-lua",
    requires = { "cmp_luasnip" }
  }

  -- Snippets
  , { "L3MON4D3/LuaSnip",
    requires = { "friendly-snippets" },
  }
  , { "rafamadriz/friendly-snippets",
    event = "InsertEnter"
  }

  -- LSP
  , { "neovim/nvim-lspconfig",
    requires = {
      "mason-lspconfig.nvim",
    },
    event = "BufReadPre",
    config = function()
      require "user.lsp"
    end
  }
  , { "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
    requires = {"nvim-lspconfig"},
    config = function()
      require "user.lsp.null-ls"
    end
  }
  , { "RRethy/vim-illuminate",
    config = function()
      require "user.illuminate"
    end,
    event = "BufReadPost",
    keys = {
      { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
      { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
    },
    opts = { delay = 200 },
  }

  -- Telescope
  , { "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      require "user.telescope"
    end
  }

  -- Treesitter
  , {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    cmd = {
      "TSInstall",
      "TSBufEnable",
      "TSBufDisable",
      "TSEnable",
      "TSDisable",
      "TSModuleInfo"
    },
    config = function()
      require "user.treesitter"
    end,
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end
  }

  -- Git
  , { "lewis6991/gitsigns.nvim",
    ft = "gitcommit",
    event = "BufReadPre",
    config = function()
      require "user.gitsigns"
    end
  }

  -- DAP
  , { "mfussenegger/nvim-dap",
    config = function()
      require "user.dap"
    end
  }
  , { "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
  }

  , { "chaoren/vim-wordmotion" } -- camel/pascal/snake/kebab case motions
  , { "XXiaoA/auto-save.nvim", -- Auto-save on InsertLeave
    config = function()
      require "user.auto-save"
    end
  }
  , { "nvim-treesitter/nvim-treesitter-textobjects", -- More context-based navigation
    requires = { "nvim-treesitter" },
  }
  , { "wellle/targets.vim" } -- More text objects, for quicker manipulation
  , {
    "Hoffs/omnisharp-extended-lsp.nvim", -- Go to definition for external symbols
    requires = { "nvim-telescope/telescope.nvim" }
  }
  , { "vim-test/vim-test",
    cmd = { "TestClass", "TestFile", "TestLast", "TestNearest", "TestSuite", "TestVisit" }
  } -- run tests based on context
  , {
    'nvim-telescope/telescope-ui-select.nvim', -- use telescope for various ui inputs
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require "telescope".load_extension("ui-select")
    end,
    fn = { vim.ui.select }
  }
  , {
    "danymat/neogen", -- generate c# xml doc
    opts = {
      languages = {
        cs = {
          template = {
            annotation_convention = "xmldoc"
          }
        }
      }
    },
    requires = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "Neogen" }
  }
  , { "hrsh7th/cmp-nvim-lsp-signature-help" } -- lsp signature (method overloads etc.)
  , { "folke/which-key.nvim",
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["d"] = { name = "+DAP" },
        ["f"] = { name = "+find" },
        ["l"] = { name = "+LSP" },
        ["t"] = { name = "+test" },
        ["r"] = { name = "+run" },
      })
    end,
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      key_labels = { ["<leader>"] = "SPC" },
    },
  } -- mini cheatsheet for keymaps on demand
  , { "ggandor/leap.nvim", -- simple and powerful search-based navigation
    config = function()
      require('leap').add_default_mappings()
    end,
    dependencies = { { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } } },
    event = "VeryLazy",
    keys = { "s", "S" }
  }
  , { "tiagovla/scope.nvim", -- limit visible buffers to active tab
    config = function()
      require("scope").setup()
    end
  }
  , { "ziontee113/syntax-tree-surfer", -- navigate and move constructs
    config = function()
      require('syntax-tree-surfer').setup {}
    end,
    cmd = { "STSSelectMasterNode", "STSSelectCurrentNode" }
  }
  , { 'akinsho/git-conflict.nvim', -- navigate and simple view of git conflicts
    config = function()
      require('git-conflict').setup()
    end,
    cmd = { "GitConflictListQf" }
  },
  {
    "glepnir/lspsaga.nvim", -- lsp UI enhancements
    config = function()
      local saga = require("lspsaga")
      saga.init_lsp_saga {
        code_action_lightbulb = {
          sign = false,
          enable_in_insert = false,
        },
        symbol_in_winbar = {
          enable = true
        }
      }
    end,
    event = "BufReadPre",
  },
  {
    "iamcco/markdown-preview.nvim", -- markdown browser preview and sync
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    'arjunmahishi/flow.nvim', -- run code from file (incl. markdown code blocks)
    opts = {
      output = {
        buffer = true,
        split_cmd = '100vsplit',
      },
      filetype_cmd_map = {
        sh = "bash <<-EOF\n%s\nEOF",
        csx = "dotnet script eval <<-EOF\n%s\nEOF",
      }
    },
    cmd = { "FlowRunFile", "FlowRunSelected" }
  }
  , {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
    cmd = "Mason",
  }
  , {
    "williamboman/mason-lspconfig.nvim",
    requires = { "mason.nvim", },
    event = "BufReadPre",
  }
  , {
    "blackadress/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    branch = "response_body_stored",
    config = function()
      require("rest-nvim").setup {}
    end,
    ft = "http",
  }
  , {
    'airblade/vim-rooter'
  }
  , {
    'rcarriga/nvim-notify',
  }
  , {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "telescope.nvim" },
    config = function()
      require "user.telescope-file-browser"
    end
  }
  , {
    "MikaelElkiaer/reprosjession.nvim",
    requires = {
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'rmagatti/auto-session'
    },
    config = function()
      require "telescope".load_extension "reprosjession"
    end
  }
  , {
    'rmagatti/auto-session',
    opts = {
      log_level = "error",
      cwd_change_handling = {
        restore_upcoming_session = true
      },
      auto_session_suppress_dirs = {
        "/home/*"
      }
    },
  }
  , {
    'mrjosh/helm-ls',
    requires = { 'towolf/vim-helm' },
    ft = "helm"
  }
  , { "valorl/vcslink.nvim",
    cmd = { "VcsLinkCopy", "VcsLinkBrowse" }
  }
  , { "dstein64/vim-startuptime",
    cmd = "StartupTime"
  }
  , { "milkias17/reloader.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    cmd = { "Reload" }
  }
  , {
    "jayp0521/mason-null-ls.nvim",
    requires = {
      "null-ls.nvim"
    },
    opts = {
      automatic_installation = true,
    },
  }
  , { 'fgheng/winbar.nvim',
    event = "BufReadPre",
    config = function()
      require "winbar".setup {}
    end,
  }
  , { "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
    opts = {
      filetypes = { "csx", "hush", "sh" }, -- filetypes to select from
    },
  }
  , { 'eandrju/cellular-automaton.nvim',
    cmd = { "CellularAutomaton" }
  }
  , { 'nvim-treesitter/playground',
    cmd = { "TSPlaygroundToggle" },
    opts = {},
  }
  , { 'taybart/b64.nvim',
    cmd = { "B64Encode", "B64Decode" }
  }
}
