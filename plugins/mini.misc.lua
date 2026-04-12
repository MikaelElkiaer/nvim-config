return {
  "nvim-mini/mini.misc",
  event = "VimEnter",
  init = function()
    local mini = require("mini.misc")
    mini.setup_auto_root()
    mini.setup_restore_cursor()
  end,
  opts = true,
}
