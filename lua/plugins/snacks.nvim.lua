local indent_ignored = {
  "help",
  "dashboard",
  "lazy",
  "notify",
  "toggleterm",
  "wk", -- which-key
}

return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    indent = {
      filter = function(buf)
        if vim.tbl_contains(indent_ignored, vim.bo[buf].filetype) then
          return false
        end

        return true
      end,
    },
  },
  priority = 1000,
}
