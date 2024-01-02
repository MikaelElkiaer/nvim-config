return {
  {
    "eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    keys = {
      { "<leader>F", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "FML" },
    },
  },
  {
    "tamton-aquib/duck.nvim",
    keys = {
      {
        "<leader>z",
        function()
          require("duck").hatch("🐢", 0.8)
        end,
        desc = "hatch turtle",
      },
      {
        "<leader>Z",
        function()
          require("duck").cook()
        end,
        desc = "cook turtle",
      },
    },
  },
  {
    "NStefan002/speedtyper.nvim",
    branch = "main",
    cmd = "Speedtyper",
    opts = {
      -- your config
    },
  },
}
