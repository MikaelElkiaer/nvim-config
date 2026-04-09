return {
  "folke/todo-comments.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "BufEnter",
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next({ keywords = { "TODO" } })
      end,
      desc = "Todo next",
    },
    {
      "]T",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Todo next - all",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev({ keywords = { "TODO" } })
      end,
      desc = "Todo prev",
    },
    {
      "[T",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Todo prev - all",
    },
    {
      "<leader>ft",
      function()
        Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
      end,
      desc = "Todo/Fix/Fixme",
    },
    {
      "<leader>fT",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo (all)",
    },
  },
  opts = {
    signs = false,
  },
}
