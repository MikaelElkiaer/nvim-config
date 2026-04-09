require("utils.init"):create_keymap_group("<leader>u", "+ui")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = { border = "rounded" },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add(require("utils.init"):get_keymap_groups())
  end,
}
