return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup {
        defaults = {

          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = { ".git/", "node_modules" },

          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>ff", ":Telescope find_files hidden=true<CR>", desc = "files" },
      { "<leader>ft",
        ":lua require'telescope.builtin'.live_grep({ additional_args = function(opts) return {'--hidden'} end})<CR>" },
      { "<leader>fb", ":Telescope buffers<CR>" },
      { "<leader>fF", ":Telescope find_files hidden=true no_ignore=true<CR>", desc = "files (all)" },
      { "<leader>fg", ":Telescope live_grep<CR>", desc = "grep" },
      { "<leader>fG",
        ":lua require'telescope.builtin'.live_grep({ additional_args = function(opts) return {'--hidden', '--no-ignore'} end})<CR>",
        "grep (all)", desc = "grep (all)" },
      { "<leader>fo", ":Telescope oldfiles only_cwd=true<CR>", desc = "old" },
      { "<leader>fO", ":Telescope oldfiles<CR>", desc = "old (all)" },
      { "<leader>fs", ":Telescope lsp_document_symbols<CR>", desc = "symbols" },
      { "<leader>fS", ":Telescope lsp_workspace_symbols<CR>", desc = "symbols (workspace)" },
    },
    version = false, -- telescope did only one release, so use HEAD for now
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function load_project(prompt_bufnr)
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local Gntry = action_state.get_selected_entry()
      end

      local fb_actions = telescope.extensions.file_browser.actions
      telescope.setup {
        extensions = {
          file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                -- your custom insert mode mappings
                ["<C-h>"] = fb_actions.goto_parent_dir,
                ["<C-l>"] = actions.select_default,
                ["<C-z><C-h>"] = fb_actions.toggle_hidden,
                ["<C-p>"] = load_project
              },
              ["n"] = {
                -- your custom normal mode mappings
                ["h"] = fb_actions.goto_parent_dir,
                ["l"] = actions.select_default,
                ["zh"] = fb_actions.toggle_hidden,
                ["p"] = load_project
              },
            },
          },
        },
      }
      telescope.load_extension "file_browser"
    end,
    keys = {
      { "<leader>fl", ":Telescope file_browser path=%:p:h initial_mode=normal hidden=true respect_gitignore=false<CR>",
        desc = "browser" },
      { "<leader>fL", ":Telescope file_browser initial_mode=normal hidden=true respect_gitignore=false<CR>",
        desc = "browser (all)" },
    },
  },
  {
    "MikaelElkiaer/reprosjession.nvim",
    config = function()
      require "telescope".load_extension "reprosjession"
    end,
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      {
        'rmagatti/auto-session',
        lazy = false,
        opts = {
          log_level = "error",
          cwd_change_handling = {
            restore_upcoming_session = true
          },
          auto_session_suppress_dirs = {
            "/home/*"
          }
        },
      },
    },
    keys = {
      { "<leader>fp", ":Telescope reprosjession root_dir=" .. vim.loop.os_homedir() .. "/Repositories<CR>",
        desc = "projects" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    config = function(_, opts)
      function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>", [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>i", [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>c", [[<C-\><C-n><C-W>c]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      local toggleterm = require("toggleterm")
      toggleterm.setup(opts)
    end,
    keys = {
      { "<leader><leader><cr>", "<cmd>ToggleTerm<CR>", desc = "default" },
      { "<leader><leader>g",
        "<cmd>lua require'toggleterm.terminal'.Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' }):toggle()<CR>",
        desc = "lazygit" },
      { "<leader><leader>d",
        "<cmd>lua require'toggleterm.terminal'.Terminal:new({ cmd = 'lazydocker', hidden = true, direction = 'float', dir='%:p:h' }):toggle()<CR>",
        desc = "lazydocker" },
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
    }
  },
  -- Autopairs, integrates with both cmp and treesitter
  {
    "windwp/nvim-autopairs",
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
    end,
    dependencies = { "nvim-cmp" },
    event = "BufReadPost",
    opts = {
      check_ts = true, -- treesitter integration
      disable_filetype = { "TelescopePrompt" },
    }
  },
  -- surround
  {
    "echasnovski/mini.surround",
    keys = { "gz" },
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
    config = function(_, opts)
      -- use gz mappings instead of s to prevent conflict with leap
      require("mini.surround").setup(opts)
    end,
  },
  -- run tests based on context
  { "vim-test/vim-test",
    cmd = { "TestClass", "TestFile", "TestLast", "TestNearest", "TestSuite", "TestVisit" },
    init = function()
      vim.g["test#csharp#runner"] = "dotnettest"
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "below 15"
    end,
    keys = {
      { "<leader>tn", "<cmd>TestNearest<CR>", desc = "nearest" },
      { "<leader>tf", "<cmd>TestFile<CR>", desc = "file" },
      { "<leader>ts", "<cmd>TestSuite<CR>", desc = "suite" },
      { "<leader>tl", "<cmd>TestLast<CR>", desc = "last" },
      { "<leader>tv", "<cmd>TestVisit<CR>-\\><C-n><C-w>l", desc = "visit" },
    },
  },
  -- generate c# xml doc
  {
    "danymat/neogen",
    cmd = { "Neogen" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      languages = {
        cs = {
          template = {
            annotation_convention = "xmldoc"
          }
        }
      }
    },
  },
}
