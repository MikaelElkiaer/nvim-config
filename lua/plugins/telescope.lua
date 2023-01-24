return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><space>", false },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { ".git/", "node_modules/" },
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      },
    }
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = telescope.extensions.file_browser.actions

      local function load_project(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local entry = action_state.get_selected_entry()
      end

      local opts = {
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
                ["<C-p>"] = load_project,
              },
              ["n"] = {
                -- your custom normal mode mappings
                ["h"] = fb_actions.goto_parent_dir,
                ["l"] = actions.select_default,
                ["zh"] = fb_actions.toggle_hidden,
                ["p"] = load_project,
              },
            },
          },
        },
      }
      telescope.setup(opts)
      telescope.load_extension("file_browser")
    end,
    keys = {
      {
        "<leader><space>",
        "<cmd>Telescope file_browser path=%:p:h initial_mode=normal hidden=true respect_gitignore=false<cr>",
        desc = "File browser",
      },
    },
  },
  {
    "MikaelElkiaer/reprosjession.nvim",
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("reprosjession")
    end,
    keys = {
      {
        "<leader>fp",
        "<cmd>Telescope reprosjession root_dir=" .. vim.loop.os_homedir() .. "/Repositories<cr>",
        desc = "Projects",
      },
    },
  },
}
