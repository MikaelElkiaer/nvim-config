require("utils.init"):create_keymap_group("<leader><leader>", "+term")

return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    config = function(_, opts)
      function _G.set_terminal_keymaps()
        local keymap_opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>", [[<C-\><C-n>]], keymap_opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-q>", [[<C-\><C-n><C-W>c]], keymap_opts)
        -- TODO: Remove once forgotten
        vim.api.nvim_buf_set_keymap(
          0,
          "t",
          "<C-w>c",
          "<cmd>lua vim.notify('Deprecated: use ^q', vim.log.levels.WARN)<cr>",
          keymap_opts
        )
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      local toggleterm = require("toggleterm")
      toggleterm.setup(opts)
    end,
    keys = {
      { "<leader><cr>", "<cmd>ToggleTerm<CR>", desc = "Terminal" },
      {
        "<leader><space>d",
        function()
          require("utils.init"):create_tui("lazydocker")
        end,
        desc = "lazydocker",
      },
      {
        "<leader><space>g",
        function()
          require("utils.init"):create_tui("lazygit")
        end,
        desc = "lazygit",
      },
      {
        "<leader><space>h",
        function()
          require("utils.init"):create_tui("gh-dash-repo")
        end,
        desc = "hub",
      },
      {
        "<leader><space>k",
        function()
          require("utils.init"):create_tui("k9s")
        end,
        desc = "k9s",
      },
    },
    opts = {
      direction = "float",
      size = 20,
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = false,
      persist_size = true,
      persist_mode = false,
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
      },
      autochdir = true,
    },
  },
}
