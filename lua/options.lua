require("vim._core.ui2").enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = "msg",
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.3, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 0.5, -- Maximum height.
    },
  },
})

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
vim.opt.backup = false
vim.opt.cmdheight = 0
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
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
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
vim.opt.winborder = "rounded"
vim.opt.wrap = true
vim.opt.writebackup = false
vim.treesitter.language.register("bash", "cheat")
vim.treesitter.language.register("c_sharp", "csx")
