vim.pack.add({
  {
    src = "https://github.com/rrethy/vim-illuminate",
    version = "master",
  },
})

require("illuminate").configure({
  filetypes_denylist = {
    "oil",
  },
  min_count_to_highlight = 2,
})
