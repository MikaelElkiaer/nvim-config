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
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "jcdickinson/wpm.nvim", opts = true },
    },
    event = "VeryLazy",
    opts = function(_, opts)
      local wpm = require("wpm")
      table.insert(opts.sections.lualine_x, wpm.wpm)
      table.insert(opts.sections.lualine_x, wpm.historic_graph)
    end,
  },
}
