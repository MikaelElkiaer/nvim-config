require("utils.init"):create_keymap_group("<leader>b", "+buffers")
local indent_ignored = {
  "help",
  "dashboard",
  "lazy",
  "notify",
  "toggleterm",
  "wk", -- which-key
}

return {
  "folke/snacks.nvim",
  keys = {

    {
      "<leader>bd",
      function()
        require("snacks").bufdelete()
        require("utils.init").on_buffer_delete()
      end,
      desc = "Delete buffer",
    },
    {
      "<leader>bD",
      function()
        require("snacks").bufdelete({ force = true })
        require("utils.init").on_buffer_delete()
      end,
      desc = "Delete buffer (force)",
    },
    {
      "<leader>ba",
      function()
        require("snacks").bufdelete.all()
        require("utils.init").on_buffer_delete()
      end,
      desc = "Delete buffers - all",
    },
    {
      "<leader>bA",
      function()
        require("snacks").bufdelete.all({ force = true })
        require("utils.init").on_buffer_delete()
      end,
      desc = "Delete buffers - all (force)",
    },
    {
      "<leader>bo",
      function()
        require("snacks").bufdelete.other()
        require("utils.init").on_buffer_delete()
      end,
      desc = "Delete buffers - others",
    },
    {
      "<leader>bO",
      function()
        require("snacks").bufdelete.other({ force = true })
        require("utils.init").on_buffer_delete()
      end,
      desc = "Delete buffers - others (force)",
    },
  },
  lazy = false,
  ---@type snacks.Config
  opts = {
    indent = {
      filter = function(buf)
        if vim.tbl_contains(indent_ignored, vim.bo[buf].filetype) then
          return false
        end

        return true
      end,
    },
  },
  priority = 1000,
}
