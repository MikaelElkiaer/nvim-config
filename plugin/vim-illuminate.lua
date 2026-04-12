vim.pack.add({ "https://github.com/rrethy/vim-illuminate" })

require("illuminate").configure({
  filetypes_denylist = {
    "oil",
  },
  min_count_to_highlight = 2,
})
