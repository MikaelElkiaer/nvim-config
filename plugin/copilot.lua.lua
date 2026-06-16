vim.pack.add({
  {
    src = "https://github.com/zbirenbaum/copilot.lua",
    version = "v3.0.0",
  },
  {
    src = "https://github.com/samiulsami/copilot-eldritch.nvim",
    version = "master",
  },
})

require("copilot").setup({
  filetypes = {
    markdown = true,
    yaml = true,
  },
  suggestion = {
    auto_trigger = true,
    enabled = true,
  },
})
require("copilot-eldritch").setup()

-- Idle tracker to disable/kill Copilot when inactive to save RAM/CPU,
-- and re-enable it automatically when returning to activity.
local idle_timer = (vim.uv or vim.loop).new_timer()
local copilot_disabled_by_idle = false
local performing_idle_action = false
local idle_timeout = 10 * 60 * 1000 -- 10 minutes in milliseconds

local function on_activity()
  if performing_idle_action then
    return
  end

  if copilot_disabled_by_idle then
    copilot_disabled_by_idle = false
    local pcall_ok, client = pcall(require, "copilot.client")
    if pcall_ok and client.is_disabled() then
      local cmd_ok, command = pcall(require, "copilot.command")
      if cmd_ok then
        performing_idle_action = true
        command.enable()
        performing_idle_action = false
      end
    end
  end

  if idle_timer then
    idle_timer:stop()
    idle_timer:start(
      idle_timeout,
      0,
      vim.schedule_wrap(function()
        local pcall_ok, client = pcall(require, "copilot.client")
        if pcall_ok and not client.is_disabled() then
          local cmd_ok, command = pcall(require, "copilot.command")
          if cmd_ok then
            performing_idle_action = true
            command.disable()
            copilot_disabled_by_idle = true
            performing_idle_action = false
          end
        end
      end)
    )
  end
end

local group = vim.api.nvim_create_augroup("CopilotIdleTracker", { clear = true })
vim.api.nvim_create_autocmd({
  "CursorMoved",
  "CursorMovedI",
  "TextChanged",
  "TextChangedI",
  "BufWinEnter",
  "FocusGained",
}, {
  group = group,
  callback = on_activity,
})

-- Initialize the idle timer on startup
on_activity()

-- Keymaps
vim.keymap.set("n", "<leader>uC", function()
  copilot_disabled_by_idle = false
  vim.cmd("Copilot toggle")
end, { desc = "Toggle Copilot" })

vim.keymap.set("i", "<M-h>", function()
  _ = require("copilot.suggestion").next()
end, { desc = "Select next Copilot suggestion" })
vim.keymap.set("i", "<M-j>", function()
  _ = require("copilot.suggestion").accept_word()
end, { desc = "Accept Copilot suggestion - word only" })
vim.keymap.set("i", "<M-k>", function()
  _ = require("copilot.suggestion").prev()
end, { desc = "Select previous Copilot suggestion" })
vim.keymap.set("i", "<M-l>", function()
  _ = require("copilot.suggestion").accept_line()
end, { desc = "Accept Copilot suggestion - line only" })
