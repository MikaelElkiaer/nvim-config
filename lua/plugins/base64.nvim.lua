return {
  "MikaelElkiaer/base64.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  keys = {
    { "<leader>Bd", '<cmd>lua require("base64").decode()<cr>', desc = "base64 decode", mode = "x" },
    { "<leader>Be", '<cmd>lua require("base64").encode()<cr>', desc = "base64 encode", mode = "x" },
  },
}
