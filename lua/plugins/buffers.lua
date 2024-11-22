require("utils").create_keymap_group("<leader>b", "+buffers")

return {
  {
    "akinsho/bufferline.nvim",
    event = "BufEnter",
    keys = {
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete others" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Buffer prev" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Buffer next" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Buffer move prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Buffer move next" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
      },
    },
  },
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
          require("utils").on_buffer_delete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function(...)
          require("mini.bufremove").wipeout(...)
          require("utils").on_buffer_delete()
        end,
        desc = "Delete Buffer (Force)",
      },
      {
        "<leader>ba",
        function()
          vim.cmd("bufdo bdelete")
          require("utils").on_buffer_delete()
        end,
        desc = "Delete buffers - All",
      },
      {
        "<leader>bA",
        function()
          vim.cmd("bufdo bwipeout")
          require("utils").on_buffer_delete()
        end,
        desc = "Delete buffers - All (Force)",
      },
    },
    opts = true,
  },
}
