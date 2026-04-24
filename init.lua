vim.diagnostic.config({
  float = {
    border = "rounded",
  },
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  virtual_text = false,
})
vim.filetype.add({
  extension = {
    bats = "bash",
    cheat = "cheat",
    csx = "csx",
    hsh = "hush",
    json = "jsonc",
    keymap = "devicetree",
    overlay = "devicetree",
  },
})
vim.g.autoformat = false
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.backup = false
vim.opt.completeopt = "menu,menuone,noinsert,noselect"
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fileencoding = "utf-8"
vim.opt.foldenable = false
vim.opt.ignorecase = true
vim.opt.jumpoptions:remove("clean")
vim.opt.laststatus = 3 -- Show global statusbar
vim.opt.list = true
vim.opt.number = true
vim.opt.scrolloff = 10
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.showtabline = 1 -- Show only on multiple tabs
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.statusline = "%f %{mode()} %{reg_recording()}"
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 500
vim.opt.virtualedit = "block"
vim.opt.wrap = true
vim.opt.writebackup = false
vim.treesitter.language.register("c_sharp", "csx")
vim.treesitter.language.register("bash", "cheat")

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

vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent decrease" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent increase" })

vim.keymap.set("n", "<leader>M", ":Man ", { desc = "Open manpage" })

vim.keymap.set("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic and display" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic and display" })

-- WARN: Does not work, probably due to lazy loading
-- local blink_ok, _ = pcall(require, "blink.cmp")
-- if not blink_ok then
--   vim.keymap.set("i", "<C-space>", function()
--     return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-X><C-O>"
--   end, { desc = "trigger completion", expr = true })
--   vim.keymap.set("i", "<esc>", function()
--     return vim.fn.pumvisible() == 1 and "<C-e><esc>" or "<esc>"
--   end, { desc = "cancel completion", expr = true })
--   vim.keymap.set("i", "<cr>", function()
--     return vim.fn.pumvisible() == 1 and "<C-y>" or "<cr>"
--   end, { desc = "confirm completion", expr = true })
--   vim.keymap.set("i", "<C-k>", function()
--     return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
--   end, { desc = "previous completion", expr = true })
--   vim.keymap.set("i", "<C-j>", function()
--     return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
--   end, { desc = "previous completion", expr = true })
-- end

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank - clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>Y", '"+Y', { desc = "Yank - clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste - clipboard" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste - clipboard" })

vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

vim.keymap.set("n", "<leader>s", ":w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>S", ":wa<cr>", { desc = "Save all files" })

vim.keymap.set("n", "<leader>U", "<cmd>packadd nvim.undotree<cr><cmd>Undotree<cr>", { desc = "Undo tree" })

vim.keymap.set("n", "grd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })

local has_notified = false

local function watch_config_dir()
  local config_path = vim.fn.stdpath("config")
  local fswatch = vim.uv.new_fs_event()
  if not fswatch then
    vim.notify(
      "Failed to create filesystem watcher for config directory.",
      vim.log.levels.ERROR,
      { title = "Config Watcher" }
    )
    return
  end
  local timer = vim.uv.new_timer()
  if not timer then
    vim.notify("Failed to create timer for config watcher.", vim.log.levels.ERROR, { title = "Config Watcher" })
    fswatch:close()
    return
  end

  vim.uv.fs_event_start(fswatch, config_path, { recursive = true }, function(err, filename, _)
    -- 1. If we already notified, immediately drop all future events
    if err or not filename or has_notified then
      return
    end

    if filename:match("^%.git[/\\]") or filename == ".git" then
      return
    end

    timer:start(200, 0, function()
      -- Double-check in case the timer was already queued
      if has_notified then
        return
      end

      vim.system({ "git", "check-ignore", "-q", filename }, { cwd = config_path }, function(obj)
        -- 2. If ignored, or if another async check beat us to the punch, abort
        if obj.code == 0 or has_notified then
          return
        end

        -- 3. Lock it down immediately so no other events can trigger
        has_notified = true

        vim.schedule(function()
          -- 4. Turn off the filesystem watcher entirely to save resources
          if not fswatch:is_closing() then
            fswatch:stop()
          end

          local msg = string.format("Config changed - restart Neovim.", filename)

          vim.notify(msg, vim.log.levels.WARN, {
            title = "Config Watcher",
            timeout = false,
          })
        end)
      end)
    end)
  end)
end

watch_config_dir()
