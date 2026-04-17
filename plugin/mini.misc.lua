vim.pack.add({
  {
    src = "https://github.com/nvim-mini/mini.misc",
    version = "main",
  },
})

local mini = require("mini.misc")
mini.setup({})
mini.setup_auto_root()
mini.setup_restore_cursor()
