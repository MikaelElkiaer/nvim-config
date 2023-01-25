return {
  {
    "MikaelElkiaer/yaml.nvim",
    cmd = "YAMLYank",
    keys = {
      { "<leader>y", '<cmd>lua require("yaml_nvim").yank_all()<cr>', desc = "yank yaml key/value" },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    cmd = "MarkdownPreview",
  },
  {
    { "towolf/vim-helm", ft = "helm" },
  },
  -- run tests based on context
  { "vim-test/vim-test",
    cmd = { "TestClass", "TestFile", "TestLast", "TestNearest", "TestSuite", "TestVisit" },
    init = function()
      vim.g["test#csharp#runner"] = "dotnettest"
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "below 15"

      require("utils").create_keymap_group("<leader>t", "+test")
    end,
    keys = {
      { "<leader>tn", "<cmd>TestNearest<CR>", desc = "nearest" },
      { "<leader>tf", "<cmd>TestFile<CR>", desc = "file" },
      { "<leader>ts", "<cmd>TestSuite<CR>", desc = "suite" },
      { "<leader>tl", "<cmd>TestLast<CR>", desc = "last" },
      { "<leader>tv", "<cmd>TestVisit<CR>-\\><C-n><C-w>l", desc = "visit" },
    },
  },
  -- generate c# xml doc
  {
    "danymat/neogen",
    cmd = { "Neogen" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      languages = {
        cs = {
          template = {
            annotation_convention = "xmldoc"
          }
        }
      }
    },
  },
}
