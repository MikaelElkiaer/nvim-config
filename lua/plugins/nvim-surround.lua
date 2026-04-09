return {
  "kylechui/nvim-surround",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
  },
  keys = {
    { "<C-g>sa", "<Plug>(nvim-surround-insert)", desc = "add", mode = "i" },
    { "<C-g>sA", "<Plug>(nvim-surround-insert-line)", desc = "add line", mode = "i" },
    { "gsa", "<Plug>(nvim-surround-normal)", desc = "add", mode = "n" },
    { "gSa", "<Plug>(nvim-surround-normal-cur)", desc = "add cursor", mode = "n" },
    { "gsA", "<Plug>(nvim-surround-normal-line)", desc = "add line", mode = "n" },
    { "gSA", "<Plug>(nvim-surround-normal-cur-line)", desc = "add", mode = "n" },
    { "gsa", "<Plug>(nvim-surround-visual)", desc = "add", mode = "x" },
    { "gsA", "<Plug>(nvim-surround-visual-line)", desc = "surround line", mode = "x" },
    { "gsd", "<Plug>(nvim-surround-delete)", desc = "delete", mode = "n" },
    { "gsc", "<Plug>(nvim-surround-change)", desc = "change", mode = "n" },
    { "gsC", "<Plug>(nvim-surround-change-line)", desc = "change line", mode = "n" },
  },
  opts = {
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
}
