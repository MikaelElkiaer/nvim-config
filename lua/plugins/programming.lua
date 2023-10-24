return {
  {
    "cuducos/yaml.nvim",
    cmd = { "YAMLYank", "YAMLYankKey", "YAMLYankValue" },
    config = function(_, _)
      require("yaml_nvim")
    end,
    keys = {
      { "<leader>yy", "<cmd>YAMLYank y<cr>", desc = "yank yaml key and value" },
      { "<leader>yk", "<cmd>YAMLYankKey y<cr>", desc = "yank yaml key" },
      { "<leader>yv", "<cmd>YAMLYankValue y<cr>", desc = "yank yaml value" },
      { "<leader>yp", "\"yp", desc = "paste yaml value" },
    },
  },
  {
    { "towolf/vim-helm", ft = "helm" },
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
            annotation_convention = "xmldoc",
          },
        },
      },
    },
  },
}
