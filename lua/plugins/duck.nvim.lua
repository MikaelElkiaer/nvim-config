return {
  "tamton-aquib/duck.nvim",
  keys = {
    {
      "<leader>z",
      function()
        require("duck").hatch("🐢", 0.8)
      end,
      desc = "Turtle hatch",
    },
    {
      "<leader>Z",
      function()
        require("duck").cook()
      end,
      desc = "Turtle cook",
    },
  },
}
