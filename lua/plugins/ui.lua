return {
  {
    "ellisonleao/gruvbox.nvim",
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.o.background = "dark"
    end,
    opts = {
      bold = false,
      italic = {
        strings = false,
        comments = false,
        operators = false,
        folds = false,
      },
      contrast = "hard",
      invert_tabline = true,
    },
  },
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end,
    event = "VeryLazy",
  },
}
