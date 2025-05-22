require("utils.init"):create_keymap_group("<leader>b", "+buffers")

return {
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
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
    opts = function()
      local bufferline = require("bufferline")
      return {
        options = {
          always_show_bufferline = true,
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          style_preset = bufferline.style_preset.no_italic,
        },
      }
    end,
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
