-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.filetype.add({
  extension = {
    keymap = "devicetree",
    overlay = "devicetree",
    bats = "bash",
    csx = "csx",
    cheat = "bash",
    hsh = "hush",
    json = "jsonc",
    gotmpl = "gotmpl",
  },
})
vim.g.autoformat = false
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.backup = false -- creates a backup file
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.guifont = "Noto Sans Mono:h10" -- the font used in graphical neovim applications
-- vim.opt.iskeyword:append("-")
vim.opt.foldenable = false -- do not fold by default
vim.opt.number = true -- set numbered lines
vim.opt.swapfile = false -- creates a swapfile
vim.opt.undofile = true -- enable persistent undo
-- vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.wrap = true -- display lines as one long line
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.treesitter.language.register('c_sharp', 'csx')
