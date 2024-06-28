return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    config = function(_, opts)
      function _G.set_terminal_keymaps()
        local keymap_opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>", [[<C-\><C-n>]], keymap_opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>i", [[<C-\><C-n>]], keymap_opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>c", [[<C-\><C-n><C-W>c]], keymap_opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], keymap_opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], keymap_opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], keymap_opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], keymap_opts)
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
          require("utils"):create_tui("lazydocker")
        end,
        desc = "lazydocker",
      },
      {
        "<leader><space>g",
        function()
          require("utils"):create_tui("lazygit")
        end,
        desc = "lazygit",
      },
      {
        "<leader><space>h",
        function()
          require("utils"):create_tui("gh-dash")
        end,
        desc = "hub",
      },
      {
        "<leader><space>k",
        function()
          require("utils"):create_tui("k9s")
        end,
        desc = "k9s",
      },
    },
    opts = {
      direction = "float",
      size = 20,
      open_mapping = [[<c-\>]],
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
      autochdir = true
    },
  },
}
