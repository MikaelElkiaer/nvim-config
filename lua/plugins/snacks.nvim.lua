require("utils.init"):create_keymap_group("<leader>b", "+buffers")
require("utils.init"):create_keymap_group("<leader>f", "+find")

return {
  "folke/snacks.nvim",
  keys = {
    -- stylua: ignore start
    -- Find
    { "<leader>,", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>ff", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fF", function() Snacks.picker.files({hidden=true}) end, desc = "Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fg", function() Snacks.picker.git_grep() end, desc = "Grep" },
    { "<leader>fG", function() Snacks.picker.grep({hidden=true}) end, desc = "Grep Open Buffers" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- Buffers
    { "<leader>bd", function() Snacks.bufdelete(); require("utils.init").on_buffer_delete() end, desc = "Delete buffer" },
    { "<leader>bD", function() Snacks.bufdelete({ force = true }); require("utils.init").on_buffer_delete() end, desc = "Delete buffer (force)" },
    { "<leader>ba", function() Snacks.bufdelete.all(); require("utils.init").on_buffer_delete() end, desc = "Delete buffers - all" },
    { "<leader>bA", function() Snacks.bufdelete.all({ force = true }); require("utils.init").on_buffer_delete() end, desc = "Delete buffers - all (force)" },
    { "<leader>bo", function() Snacks.bufdelete.other(); require("utils.init").on_buffer_delete() end, desc = "Delete buffers - others" },
    { "<leader>bO", function() Snacks.bufdelete.other({ force = true }); require("utils.init").on_buffer_delete() end, desc = "Delete buffers - others (force)" },
    -- stylua: ignore end
  },
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      layout = {
        preset = "custom",
      },
      layouts = {
        ["custom"] = {
          reverse = true,
          layout = {
            box = "horizontal",
            width = 0.9,
            height = 0.9,
            {
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
            { win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
          },
        },
      },
    },
  },
  priority = 1000,
}
