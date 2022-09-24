local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
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

local lazy_load = function(tb)
  vim.api.nvim_create_autocmd(tb.events, {
    group = vim.api.nvim_create_augroup(tb.augroup_name, {}),
    callback = function()
      if tb.condition() then
        vim.api.nvim_del_augroup_by_name(tb.augroup_name)

        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if tb.plugin ~= "nvim-treesitter" then
          vim.defer_fn(function()
            require("packer").loader(tb.plugin)
            if tb.plugin == "nvim-lspconfig" then
              vim.cmd "silent! do FileType"
            end
          end, 0)
        else
          require("packer").loader(tb.plugin)
        end
      end
    end,
  })
end

local on_file_open = function(plugin_name)
  lazy_load {
    events = { "BufRead", "BufWinEnter", "BufNewFile" },
    augroup_name = "BeLazyOnFileOpen" .. plugin_name,
    plugin = plugin_name,
    condition = function()
      local file = vim.fn.expand "%"
      return file ~= "NvimTree_1" and file ~= "[packer]" and file ~= ""
    end,
  }
end

local gitsigns = function()
  vim.api.nvim_create_autocmd({ "BufRead" }, {
    group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
    callback = function()
      vim.fn.system("git rev-parse " .. vim.fn.expand "%:p:h")
      if vim.v.shell_error == 0 then
        vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
        vim.schedule(function()
          require("packer").loader "gitsigns.nvim"
        end)
      end
    end,
  })
end

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use { "wbthomason/packer.nvim",
    cmd = {
      "PackerSnapshot",
      "PackerSnapshotRollback",
      "PackerSnapshotDelete",
      "PackerInstall",
      "PackerUpdate",
      "PackerSync",
      "PackerClean",
      "PackerCompile",
      "PackerStatus",
      "PackerProfile",
      "PackerLoad"
    }
  } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim",
    module = "plenary"
  } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs",
    after = "nvim-cmp"
  } -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim",
    module = "Comment",
  }
  use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use { "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons"
  }
  use { "akinsho/bufferline.nvim" }
  use { "moll/vim-bbye" }
  use { "nvim-lualine/lualine.nvim" }
  use { "akinsho/toggleterm.nvim" }
  use { "lewis6991/impatient.nvim" }
  use { "lukas-reineke/indent-blankline.nvim",
    opt = true,
    setup = function()
      on_file_open "indent-blankline.nvim"
    end
  }

  -- Colorschemes
  use { "folke/tokyonight.nvim" }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp",
    after = "friendly-snippets"
  } -- The completion plugin
  use { "hrsh7th/cmp-buffer",
    after = "cmp-nvim-lsp"
  } -- buffer completions
  use { "hrsh7th/cmp-path",
    after = "cmp-buffer"
  } -- path completions
  use { "saadparwaiz1/cmp_luasnip",
    after = "LuaSnip"
  } -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp",
    after = "cmp-nvim-lua"
  }
  use { "hrsh7th/cmp-nvim-lua",
    after = "cmp_luasnip"
  }

  -- snippets
  use { "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    after = "nvim-cmp"
  } --snippet engine
  use { "rafamadriz/friendly-snippets",
    module = { "cmp", "cmp_nvim_lsp" },
    event = "InsertEnter"
  } -- a bunch of snippets to use

  -- LSP
  use { "neovim/nvim-lspconfig" } -- enable LSP
  use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters
  use { "RRethy/vim-illuminate" }

  -- Telescope
  use { "nvim-telescope/telescope.nvim",
    cmd = "Telescope"
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    module = "nvim-treesitter",
    setup = function()
      on_file_open "nvim-treesitter"
    end,
    cmd = {
      "TSInstall",
      "TSBufEnable",
      "TSBufDisable",
      "TSEnable",
      "TSDisable",
      "TSModuleInfo"
    }
  }

  -- Git
  use { "lewis6991/gitsigns.nvim",
    ft = "gitcommit",
    setup = function()
      gitsigns()
    end
  }

  -- DAP
  use { "mfussenegger/nvim-dap" }
  use { "rcarriga/nvim-dap-ui", module_pattern = "dapui.*" }

  -- MikaelElkiaer/
  use { "chaoren/vim-wordmotion" } -- camel/pascal/snake/kebab case motions
  use { "XXiaoA/auto-save.nvim",
    config = function()
      require('auto-save').setup {
        condition = function(buf)
          local fn = vim.fn
          local utils = require("auto-save.utils.data")

          if fn.getbufvar(buf, "&modifiable") == 1
              and
              utils.not_in(fn.getbufvar(buf, "&filetype"), {})
              and
              utils.not_in(fn.expand("%:t"), {
                "plugins.lua",
                "auto-save.lua",
              })
          then
            return true -- met condition(s), can save
          end
          return false -- can't save
        end,
      }
    end
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = "nvim-treesitter"
  }
  use { "wellle/targets.vim" } -- more text objects for quicker manipulation
  use {
    "Hoffs/omnisharp-extended-lsp.nvim", -- goto definition for external symbols
    requires = { { "nvim-telescope/telescope.nvim" } }
  }
  use { "vim-test/vim-test",
    cmd = { "TestClass", "TestFile", "TestLast", "TestNearest", "TestSuite", "TestVisit" }
  } -- run tests based on context
  use { "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew" }
  } -- scratchpad for scripting
  use {
    'nvim-telescope/telescope-ui-select.nvim', -- use telescope for various ui inputs
    requires = { { "nvim-telescope/telescope.nvim" } },
    config = function()
      require("telescope").load_extension("ui-select")
    end
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
    disable = true,
    module = "which-key",
    keys = { "<leader>", "'", '"', "`" }
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
  use { 'kevinhwang91/nvim-ufo', -- lsp-based folds
    requires = 'kevinhwang91/promise-async',
    config = function()
      require('ufo').setup()
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
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    }
  }
  use {
    "williamboman/mason-lspconfig.nvim",
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig"
    },
    setup = function()
      on_file_open("nvim-lspconfig")
    end
  }
  use {
    "blackadress/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    branch = "response_body_stored",
    config = function()
      require("rest-nvim").setup {}
    end,
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
    "nvim-telescope/telescope-file-browser.nvim"
  }
  use {
    "MikaelElkiaer/reprosjession.nvim",
    requires = {
      'telescope.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'rmagatti/auto-session'
    },
    config = function()
      require "telescope".load_extension "reprosjession"
    end
  }
  use {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
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
  -- /MikaelElkiaer

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
