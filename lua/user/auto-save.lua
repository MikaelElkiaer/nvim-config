local status_ok, auto_save = pcall(require, "auto-save")
if not status_ok then
  return
end

auto_save.setup {
  condition = function(buf)
    local utils = require("auto-save.utils.data")

    if vim.fn.getbufvar(buf, "&modifiable") == 1
        and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), {})
        and utils.not_in(vim.fn.expand("%:t"), {
          "plugins.lua",
          "auto-save.lua",
          "picom.conf",
          "wezterm.lua"
        })
    then
      return true
    end

    return false
  end,
}
