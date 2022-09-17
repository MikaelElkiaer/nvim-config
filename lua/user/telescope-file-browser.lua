local telescope_status_ok, telescope = pcall(require, "telescope")
if not telescope_status_ok then
  return
end

local actions_status_ok, actions = pcall(require, "telescope.actions")
if not actions_status_ok then
  return
end

local actions_state_status_ok, action_state = pcall(require, "telescope.actions.state")
if not actions_state_status_ok then
  return
end

-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
local function load_project(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  require 'notify' ("Load project via file: " .. entry[1])
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
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension "file_browser"
