require("utils.init"):create_keymap_group("<leader>b", "+buffers")

return {
  {
    "tiagovla/scope.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function(...)
          require("mini.bufremove").delete(...)
          require("utils.init").on_buffer_delete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function(...)
          require("mini.bufremove").wipeout(...)
          require("utils.init").on_buffer_delete()
        end,
        desc = "Delete Buffer (Force)",
      },
      {
        "<leader>ba",
        function()
          vim.cmd("bufdo bdelete")
          require("utils.init").on_buffer_delete()
        end,
        desc = "Delete buffers - All",
      },
      {
        "<leader>bA",
        function()
          vim.cmd("bufdo bwipeout")
          require("utils.init").on_buffer_delete()
        end,
        desc = "Delete buffers - All (Force)",
      },
    },
    opts = true,
  },
}
