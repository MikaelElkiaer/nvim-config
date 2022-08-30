local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use { "wbthomason/packer.nvim" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs" } -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim" }
  use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use { "kyazdani42/nvim-web-devicons" }
  use { "kyazdani42/nvim-tree.lua" }
  use { "akinsho/bufferline.nvim" }
  use { "moll/vim-bbye" }
  use { "nvim-lualine/lualine.nvim" }
  use { "akinsho/toggleterm.nvim" }
  use { "ahmedkhalf/project.nvim" }
  use { "lewis6991/impatient.nvim" }
  use { "lukas-reineke/indent-blankline.nvim" }
  use { "goolord/alpha-nvim" }

  -- Colorschemes
  use { "folke/tokyonight.nvim", commit = "8223c970677e4d88c9b6b6d81bda23daf11062bb" }
  use { "lunarvim/darkplus.nvim", commit = "2584cdeefc078351a79073322eb7f14d7fbb1835" }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp" } -- The completion plugin
  use { "hrsh7th/cmp-buffer" } -- buffer completions
  use { "hrsh7th/cmp-path" } -- path completions
  use { "saadparwaiz1/cmp_luasnip" } -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-nvim-lua" }

  -- snippets
  use { "L3MON4D3/LuaSnip" } --snippet engine
  use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use

  -- LSP
  use { "neovim/nvim-lspconfig" } -- enable LSP
  use { "williamboman/nvim-lsp-installer" } -- simple to use language server installer
  use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters
  use { "RRethy/vim-illuminate" }

  -- Telescope
  use { "nvim-telescope/telescope.nvim" }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter"
  }

  -- Git
  use { "lewis6991/gitsigns.nvim" }

  -- DAP
  use { "mfussenegger/nvim-dap" }
  use { "rcarriga/nvim-dap-ui" }
  use { "ravenxrz/DAPInstall.nvim" }

  -- MikaelElkiaer/
  use { "chaoren/vim-wordmotion" }
  use { "XXiaoA/auto-save.nvim",
    config = function()
      require('auto-save').setup { }
    end
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = "nvim-treesitter"
  }
  use { "wellle/targets.vim" }
  use {
    "Hoffs/omnisharp-extended-lsp.nvim",
    requires = { { "nvim-telescope/telescope.nvim" } }
  }
  use { "vim-test/vim-test" }
  use {
    "francoiscabrol/ranger.vim",
    requires = { { "rbgrouleff/bclose.vim" } }
  }
  use { "metakirby5/codi.vim" }
  use {
    'nvim-telescope/telescope-ui-select.nvim',
    requires = { { "nvim-telescope/telescope.nvim" } },
    config = function()
      require("telescope").load_extension("ui-select")
    end
  }
  use {
    "danymat/neogen",
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
    requires = "nvim-treesitter/nvim-treesitter"
  }
  use { "hrsh7th/cmp-nvim-lsp-signature-help" }
  use { "folke/which-key.nvim" }
  use { "ggandor/leap.nvim",
    config = function()
      require('leap').set_default_keymaps()
    end
  }
  use { "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end
  }
  use { 'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    config = function()
      require('ufo').setup()
    end
  }
  use { 'LunarVim/onedarker.nvim' }
  use { 'nvim-treesitter/nvim-treesitter-context',
    requires = 'nvim-treesitter/nvim-treesitter'
  }
  use { "ziontee113/syntax-tree-surfer",
    config = function()
      require('syntax-tree-surfer').setup {}
    end
  }
  use { 'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup()
    end
  }
  use({
      "glepnir/lspsaga.nvim",
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
  })
  use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
  })
  use({
    'arjunmahishi/run-code.nvim'
  })
  -- /MikaelElkiaer

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
