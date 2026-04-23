vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    version = "master",
  },
})
vim.pack.add({
  {
    src = "https://github.com/stevearc/oil.nvim",
    version = "master",
  },
})

require("oil").setup({
  keymaps = {
    ["<localleader>fg"] = {
      function()
        local has_snacks, snacks = pcall(require, "snacks")
        if has_snacks then
          snacks.picker.grep({ dirs = { require("oil").get_current_dir() }, ignored = true, hidden = true })
        else
          vim.notify("Snacks not found", vim.log.levels.WARN)
        end
      end,
      desc = "Grep - All",
      mode = "n",
    },
  },
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "<leader>o", '<cmd>lua require("oil").open()<cr>', { desc = "Oil cwd" })
