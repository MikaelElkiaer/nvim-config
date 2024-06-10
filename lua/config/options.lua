vim.filetype.add({
  extension = {
    bats = "bash",
    cheat = "bash",
    csx = "csx",
    hsh = "hush",
    json = "jsonc",
    keymap = "devicetree",
    overlay = "devicetree",
  },
})
vim.g.autoformat = false
vim.g.mapleader = " "
vim.g.maplocalleader = "<BS>"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.backup = false
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
vim.opt.completeopt = "menu,menuone,noinsert,noselect"
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.fileencoding = "utf-8"
vim.opt.foldenable = false
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.virtualedit = "block"
vim.opt.wrap = true
vim.opt.writebackup = false
vim.treesitter.language.register("c_sharp", "csx")
