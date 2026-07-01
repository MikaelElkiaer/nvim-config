vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    version = "master",
  },
  {
    src = "https://github.com/nvimdev/dashboard-nvim",
    version = "master",
  },
})

local logo = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
logo = string.rep("\n", 10) .. logo .. string.rep("\n", 5)

require("dashboard").setup({
  config = {
    center = {
      {
        action = "Oil ",
        desc = " Open Oil",
        icon = " ",
        key = "o",
      },
      {
        action = 'lua require("fzf-lua").files()',
        desc = " Find Files",
        icon = " ",
        key = "f",
      },
      {
        action = 'lua require("fzf-lua").oldfiles()',
        desc = " Recent Files",
        icon = " ",
        key = "r",
      },
      {
        action = 'lua require("persistence").load()',
        desc = " Session Restore",
        icon = " ",
        key = "s",
      },
      {
        action = function()
          vim.api.nvim_input("<cmd>qa<cr>")
        end,
        desc = " Quit",
        icon = " ",
        key = "q",
      },
    },
    footer = { "" },
    header = vim.split(logo, "\n"),
  },
  theme = "doom",
})
