-- Bootstrap packer - see https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end 
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup({ function(use)
  use { "wbthomason/packer.nvim", -- Packer can manage itself
    module = "packer",
    cmd = { "PackerSnapshot", "PackerSnapshotRollback", "PackerSnapshotDelete", "PackerInstall", "PackerUpdate",
      "PackerSync", "PackerClean", "PackerCompile", "PackerStatus", "PackerProfile", "PackerLoad" },
    config = function()
      require "user.plugins"
    end
  }
  use { "nvim-lua/plenary.nvim", -- Useful utils
    module = "plenary"
  }
  use { "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
    after = "nvim-cmp",
    config = function()
      require "user.autopairs"
    end
  }
  use { "numToStr/Comment.nvim",
    module = "Comment",
    config = function()
      require "user.comment"
    end
  }
  use { "JoosepAlviste/nvim-ts-context-commentstring",
    requires = { "nvim-treesitter" },
    after = "nvim-treesitter"
  }
  use { "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons"
  }
  use { "akinsho/bufferline.nvim",
    config = function()
      require "user.bufferline"
    end
  }
  use { "moll/vim-bbye" }
  use { "nvim-lualine/lualine.nvim",
    config = function()
      require "user.lualine"
    end
  }
  use { "akinsho/toggleterm.nvim",
    config = function()
      require "user.toggleterm"
    end,
  }
  use { "lewis6991/impatient.nvim",
    config = function()
      require "user.impatient"
    end,
  }
  use { "lukas-reineke/indent-blankline.nvim",
    opt = true,
    setup = function()
      require "user.utils".on_file_open "indent-blankline.nvim"
    end,
    config = function()
      require "user.indentline"
    end,
  }

  -- Colorschemes
  use {
    "ellisonleao/gruvbox.nvim",
    config = function()
      vim.o.background = "dark"
      require("gruvbox").setup {
        bold = false,
        italic = false,
        contrast = "hard"
      }
      vim.api.nvim_command "colorscheme gruvbox"
    end
  }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp", -- The completion plugin
    after = "friendly-snippets",
    config = function()
      require "user.cmp"
    end,
  }
  use { "hrsh7th/cmp-buffer",
    after = "cmp-nvim-lsp"
  }
  use { "hrsh7th/cmp-path",
    after = "cmp-buffer"
  }
  use { "saadparwaiz1/cmp_luasnip",
    after = "LuaSnip"
  }
  use { "hrsh7th/cmp-nvim-lsp",
    after = "cmp-nvim-lua"
  }
  use { "hrsh7th/cmp-nvim-lua",
    after = "cmp_luasnip"
  }

  -- Snippets
  use { "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    after = "nvim-cmp"
  }
  use { "rafamadriz/friendly-snippets",
    module = { "cmp", "cmp_nvim_lsp" },
    event = "InsertEnter"
  }

  -- LSP
  use { "neovim/nvim-lspconfig",
    opt = true,
    setup = function()
      require "user.utils".on_file_open("nvim-lspconfig")
    end,
    config = function()
      require "user.lsp"
    end
  }
  use { "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require "user.lsp.null-ls"
    end
  } -- for formatters and linters
  use { "RRethy/vim-illuminate",
    config = function()
      require "user.illuminate"
    end
  }

  -- Telescope
  use { "nvim-telescope/telescope.nvim",
    module = "telescope",
    cmd = "Telescope",
    config = function()
      require "user.telescope"
    end
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    module = "nvim-treesitter",
    setup = function()
      require "user.utils".on_file_open "nvim-treesitter"
    end,
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
    end
  }

  -- Git
  use { "lewis6991/gitsigns.nvim",
    ft = "gitcommit",
    setup = function()
      require "user.utils".gitsigns()
    end,
    config = function()
      require "user.gitsigns"
    end
  }

  -- DAP
  use { "mfussenegger/nvim-dap",
    module = "dap",
    config = function()
      require "user.dap"
    end
  }
  use { "rcarriga/nvim-dap-ui",
    requires = "mfussenegger/nvim-dap",
    module = "dapui"
  }

  use { "chaoren/vim-wordmotion" } -- camel/pascal/snake/kebab case motions
  use { "XXiaoA/auto-save.nvim", -- Auto-save on InsertLeave
    config = function()
      require "user.auto-save"
    end
  }
  use { "nvim-treesitter/nvim-treesitter-textobjects", -- More context-based navigation
    requires = "nvim-treesitter",
    after = "nvim-treesitter"
  }
  use { "wellle/targets.vim" } -- More text objects, for quicker manipulation
  use {
    "Hoffs/omnisharp-extended-lsp.nvim", -- Go to definition for external symbols
    requires = { "nvim-telescope/telescope.nvim" }
  }
  use { "vim-test/vim-test",
    cmd = { "TestClass", "TestFile", "TestLast", "TestNearest", "TestSuite", "TestVisit" }
  } -- run tests based on context
  use { "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew" }
  } -- scratchpad for scripting
  use {
    'nvim-telescope/telescope-ui-select.nvim', -- use telescope for various ui inputs
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require "telescope".load_extension("ui-select")
    end,
    fn = { vim.ui.select }
  }
  use {
    "danymat/neogen", -- generate c# xml doc
    config = function()
      require('neogen').setup {
        languages = {
          cs = {
            template = {
              annotation_convention = "xmldoc"
            }
          }
        }
      }
    end,
    requires = "nvim-treesitter/nvim-treesitter",
    cmd = { "Neogen" }
  }
  use { "hrsh7th/cmp-nvim-lsp-signature-help" } -- lsp signature (method overloads etc.)
  use { "folke/which-key.nvim",
    opt = true,
    module = "which-key",
    keys = { "<leader>", "'", '"', "`", "g" },
    config = function()
      require "user.which-key"
    end
  } -- mini cheatsheet for keymaps on demand
  use { "ggandor/leap.nvim", -- simple and powerful search-based navigation
    config = function()
      require('leap').set_default_keymaps()
    end,
    keys = { "s", "S" }
  }
  use { "tiagovla/scope.nvim", -- limit visible buffers to active tab
    config = function()
      require("scope").setup()
    end
  }
  use { 'nvim-treesitter/nvim-treesitter-context', -- display parent context for nested constructs
    requires = 'nvim-treesitter/nvim-treesitter'
  }
  use { "ziontee113/syntax-tree-surfer", -- navigate and move constructs
    config = function()
      require('syntax-tree-surfer').setup {}
    end,
    cmd = { "STSSelectMasterNode", "STSSelectCurrentNode" }
  }
  use { 'akinsho/git-conflict.nvim', -- navigate and simple view of git conflicts
    config = function()
      require('git-conflict').setup()
    end,
    cmd = { "GitConflictListQf" }
  }
  use({
    "glepnir/lspsaga.nvim", -- lsp UI enhancements
    branch = "main",
    config = function()
      local saga = require("lspsaga")
      saga.init_lsp_saga {
        code_action_lightbulb = {
          sign = false,
          enable_in_insert = false,
        },
      }
    end,
    cmd = "Lspsaga"
  })
  use({
    "iamcco/markdown-preview.nvim", -- markdown browser preview and sync
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use({
    'arjunmahishi/run-code.nvim', -- run code from file (incl. markdown code blocks)
    config = function()
      require('run-code').setup {
        output = {
          buffer = true,
          split_cmd = '100vsplit',
        }
      }
    end,
    cmd = { "RunCodeFile", "RunCodeBlock", "RunCodeSelected" }
  })
  use {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    module = "mason"
  }
  use {
    "williamboman/mason-lspconfig.nvim",
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig"
    },
    setup = function()
      require "user.utils".on_file_open("nvim-lspconfig")
    end
  }
  use {
    "blackadress/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    branch = "response_body_stored",
    config = function()
      require("rest-nvim").setup {}
    end,
    ft = "http",
    module = "rest-nvim"
  }
  use {
    'airblade/vim-rooter'
  }
  use {
    'rcarriga/nvim-notify',
    module = "notify"
  }
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = "nvim-telescope/telescope.nvim",
    after = "telescope.nvim",
    config = function()
      require "user.telescope-file-browser"
    end
  }
  use {
    "MikaelElkiaer/reprosjession.nvim",
    requires = {
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'rmagatti/auto-session'
    },
    after = { "telescope.nvim", "telescope-file-browser.nvim", "auto-session" },
    config = function()
      require "telescope".load_extension "reprosjession"
    end
  }
  use {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        cwd_change_handling = {
          restore_upcoming_session = true
        }
      }
    end
  }
  use {
    'mrjosh/helm-ls',
    requires = { 'towolf/vim-helm' },
    ft = "helm"
  }
  use { "valorl/vcslink.nvim",
    module = "vcslink",
    cmd = { "VcsLinkCopy", "VcsLinkBrowse" }
  }
  use { "dstein64/vim-startuptime",
    cmd = "StartupTime"
  }
  -- /MikaelElkiaer

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})
