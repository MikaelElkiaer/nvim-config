return {
  "folke/snacks.nvim",
  keys = {
    -- stylua: ignore start
    -- picker
    { "<leader>,", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>ff", function() Snacks.picker.git_files({untracked=true}) end, desc = "Find Git Files" },
    { "<leader>fF", function() Snacks.picker.files({hidden=true}) end, desc = "Find Files" },
    { "<leader>fhf", function() Snacks.picker.files({hidden=false}) end, desc = "Find Files - No hidden" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fg", function() Snacks.picker.grep({hidden=true}) end, desc = "Grep" },
    { "<leader>fG", function() Snacks.picker.grep({ignored=true,hidden=true}) end, desc = "Grep - All" },
    { "<leader>fhg", function() Snacks.picker.grep({hidden=false}) end, desc = "Grep - No hidden" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>fx", function() Snacks.picker() end, desc = "Find picker" },
    -- bufdelete
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>bD", function() Snacks.bufdelete({ force = true }) end, desc = "Delete buffer (force)" },
    { "<leader>ba", function() Snacks.bufdelete.all() end, desc = "Delete buffers - all" },
    { "<leader>bA", function() Snacks.bufdelete.all({ force = true }) end, desc = "Delete buffers - all (force)" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete buffers - others" },
    { "<leader>bO", function() Snacks.bufdelete.other({ force = true }) end, desc = "Delete buffers - others (force)" },
    -- notifier
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Hide notifications" },
    -- stylua: ignore end
  },
  lazy = false,
  ---@type snacks.Config
  opts = {
    notifier = {
      enabled = true,
    },
    picker = {
      formatters = {
        file = {
          truncate = 100,
        },
      },
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
      ui_select = true,
    },
  },
  priority = 1000,
}
