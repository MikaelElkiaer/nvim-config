return {
  "rrethy/vim-illuminate",
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
  event = "BufEnter",
  opts = {
    filetypes_denylist = {
      "oil",
    },
    min_count_to_highlight = 2,
  },
}
