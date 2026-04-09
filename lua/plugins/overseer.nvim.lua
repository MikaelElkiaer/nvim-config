require("utils.init"):create_keymap_group("<leader>r", "+run")

return {
  "stevearc/overseer.nvim",
  keys = {
    {
      "<leader>rt",
      "<cmd>OverseerRun<cr>",
      desc = "Run task (Overseer)",
    },
    {
      "<leader>rT",
      "<cmd>OverseerToggle<cr>",
      desc = "Toggle task list (Overseer)",
    },
  },
  lazy = false,
  opts = {},
}
