return {
  "pwntester/octo.nvim",
  cmd = { "Octo", "Octo " },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/snacks.nvim",
  },
  init = function()
    require("utils.init"):create_keymap_group("<leader>go", "+octo")
  end,
  keys = {
    {
      "<leader>goo",
      ":Octo ",
      desc = "octo cmd",
    },
    {
      "<leader>goil",
      "<cmd>Octo issue list<cr>",
      desc = "octo issue list",
    },
    {
      "<leader>goic",
      "<cmd>Octo issue create<cr>",
      desc = "octo issue create",
    },
    {
      "<leader>gopl",
      "<cmd>Octo pr list<cr>",
      desc = "octo pr list",
    },
    {
      "<leader>gopc",
      "<cmd>Octo pr create<cr>",
      desc = "octo pr create",
    },
    {
      "<leader>gor",
      "<cmd>Octo review<cr>",
      desc = "octo review",
    },
  },
  opts = {
    picker = "snacks",
  },
}
