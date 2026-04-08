require("utils.init"):create_keymap_group("<leader>u", "+ui")

return {
  {
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
  },
  {
    "nvim-mini/mini.misc",
    event = "VimEnter",
    init = function()
      local mini = require("mini.misc")
      mini.setup_auto_root()
      mini.setup_restore_cursor()
    end,
    opts = true,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = true,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
      },
      presets = {
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
}
