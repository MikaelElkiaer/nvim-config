return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = {
      "TSInstall",
      "TSBufEnable",
      "TSBufDisable",
      "TSEnable",
      "TSDisable",
      "TSModuleInfo"
    },
    config = function()
      local configs = require("nvim-treesitter.configs")
      local parsers = require "nvim-treesitter.parsers"

      parsers.filetype_to_parsername.csx = "c_sharp"

      local parser_configs = parsers.get_parser_configs()
      parser_configs.hush = {
        install_info = {
          url = "https://github.com/mikaelelkiaer/tree-sitter-hush", -- local path or git repo
          files = { "src/parser.c" },
          -- optional entries:
          branch = "main", -- default branch in case of git repo if different from master
          generate_requires_npm = false, -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
      }

      configs.setup({
        context_commentstring = { enable = true, enable_autocmd = false },
        ensure_installed = "all", -- one of "all" or a list of languages
        sync_install = false,
        ignore_install = { "" }, -- List of parsers to ignore installing
        highlight = { enable = true, }, -- false will disable the whole extension
        indent = { enable = true },
      })
    end,
    event = "BufReadPost"
  },
  {
    'nvim-treesitter/playground',
    cmd = "TSPlaygroundToggle",
    opts = true,
  },
  -- navigate and move constructs
  {
    "ziontee113/syntax-tree-surfer",
    cmd = { "STSSelectMasterNode", "STSSelectCurrentNode" },
    keys = {
      -- Normal Mode Swapping:
      -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
      { "vU", function()
        vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
        return "g@l"
      end },
      { "vD", function()
        vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
        return "g@l"
      end },
      -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
      { "vd", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
        return "g@l"
      end },
      { "vu", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
        return "g@l"
      end },
      -- Visual Selection from Normal Mode
      { "vx", '<cmd>STSSelectMasterNode<cr>' },
      { "vn", '<cmd>STSSelectCurrentNode<cr>' },
      -- Select Nodes in Visual Mode
      { "J", '<cmd>STSSelectNextSiblingNode<cr>', mode = "x" },
      { "K", '<cmd>STSSelectPrevSiblingNode<cr>', mode = "x" },
      { "H", '<cmd>STSSelectParentNode<cr>', mode = "x" },
      { "L", '<cmd>STSSelectChildNode<cr>', mode = "x" },
      -- Swapping Nodes in Visual Mode
      { "<A-j>", '<cmd>STSSwapNextVisual<cr>', mode = "x" },
      { "<A-k>", '<cmd>STSSwapPrevVisual<cr>', mode = "x" },
    },
    opts = true,
  },
  -- comments
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },

  -- better text-objects
  {
    "echasnovski/mini.ai",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- no need to load the plugin, since we only need its queries
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        end,
      },
    },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      local ai = require("mini.ai")
      ai.setup(opts)
    end,
  },
}
