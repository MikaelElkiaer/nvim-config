-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Treat kubeconfigs as yaml
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    vim.bo.filetype = "yaml"
  end,
  pattern = vim.fn.expand("~") .. "/.kube/config*",
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("man_unlisted", { clear = true }),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Disable indentkeys for yaml files to prevent unwanted auto-indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.indentkeys:remove({ "0#", "<:>" })
  end,
})

-- Fix formatoptions
-- needs to be done here as they are often overridden
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove("r") -- Do not automatically insert comment leader on linebreak
    vim.opt.formatoptions:remove("t") -- Do not automatically hardwrap based on textwidth (max_line_length)
  end,
})

-- Set winhighlight for msg window to match the rest of the UI
vim.api.nvim_create_autocmd("FileType", {
  pattern = "msg",
  callback = function()
    local ui2 = require("vim._core.ui2")
    local win = ui2.wins and ui2.wins.msg
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_option_value(
        "winhighlight",
        "Normal:NormalFloat,FloatBorder:FloatBorder",
        { scope = "local", win = win }
      )
    end
  end,
})

-- Listen for OSC 11 responses to detect terminal background color changes
-- source: https://github.com/afonsofrancof/OSC11.nvim
local parse_osc11_response = function(sequence)
  local r, g, b = sequence:match("\027%]11;rgb:(%x+)/(%x+)/(%x+)")

  if r and g and b then
    -- Convert hex to decimal and calculate luminance
    local rr = tonumber(r, 16) / 65535
    local gg = tonumber(g, 16) / 65535
    local bb = tonumber(b, 16) / 65535

    -- Same luminance calculation as Neovim uses
    local luminance = (0.299 * rr) + (0.587 * gg) + (0.114 * bb)

    return luminance < 0.5 and "dark" or "light"
  end

  return nil
end

local handle_theme_change = function(theme)
  vim.schedule(function()
    if theme then
      vim.o.background = theme
    end

    vim.cmd("redraw!")
  end)
end

vim.api.nvim_create_autocmd("TermResponse", {
  pattern = "*",
  callback = function(args)
    local sequence = args.data.sequence

    local theme = parse_osc11_response(sequence)
    if theme then
      handle_theme_change(theme)
    end
  end,
})
