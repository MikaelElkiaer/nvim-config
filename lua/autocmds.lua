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
