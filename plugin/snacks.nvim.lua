vim.pack.add({
  {
    src = "https://github.com/folke/snacks.nvim",
    version = "v2.31.0",
  },
})

require("snacks").setup({
  picker = {
    actions = {
      open_oil = function(picker)
        local dir = picker:dir()
        local has_oil, oil = pcall(require, "oil")
        if has_oil then
          picker:close()
          oil.open(dir)
        else
          vim.notify("No oil.nvim found, unable to open file explorer", vim.log.levels.WARN)
        end
      end,
    },
    formatters = {
      file = {
        truncate = 100,
      },
    },
    layout = {
      preset = "custom",
    },
    layouts = {
      ["custom"] = {
        reverse = true,
        layout = {
          box = "horizontal",
          width = 0.9,
          height = 0.9,
          {
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            { win = "list", border = "none" },
            { win = "input", height = 1, border = "top" },
          },
          { win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
        },
      },
    },
    ui_select = true,
    win = {
      input = {
        keys = {
          ["<c-o>"] = { "open_oil", mode = { "n", "i" } },
        },
      },
      list = {
        keys = {
          ["<c-o>"] = { "open_oil", mode = { "n", "i" } },
        },
      },
    },
  },
})

local function handle_oil_dir(opts)
  local has_oil, oil = pcall(require, "oil")
  if not has_oil then
    return opts
  end

  local buf_id = vim.api.nvim_get_current_buf()

  local is_oil = vim.bo[buf_id].filetype == "oil"
  if not is_oil then
    return opts
  end

  local dir = oil.get_current_dir(buf_id)
  if dir == nil then
    return opts
  end

  return vim.tbl_deep_extend("force", opts, { dirs = { dir } })
end

local on_buf_delete = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
  if not is_empty then
    return
  end

  local orig_cwd = os.getenv("PWD")
  if orig_cwd ~= nil then
    vim.fn.chdir(orig_cwd)
  end
  -- WARN: Delete final buffer before opening oil
  vim.api.nvim_buf_delete(buf_id, {})

  local has_oil, oil = pcall(require, "oil")
  if has_oil then
    oil.open()
  else
    vim.notify("No oil.nvim found, unable to open file explorer", vim.log.levels.WARN)
  end
end

-- picker
vim.keymap.set("n", "<leader>,", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>ff", function()
  local opts = { hidden = true }
  opts = handle_oil_dir(opts)
  Snacks.picker.files(opts)
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fF", function()
  local opts = { ignored = true, hidden = true }
  opts = handle_oil_dir(opts)
  Snacks.picker.files(opts)
end, { desc = "Find Files - With ignored" })
vim.keymap.set("n", "<leader>fhf", function()
  local opts = {}
  opts = handle_oil_dir(opts)
  Snacks.picker.files(opts)
end, { desc = "Find Files - No hidden" })
vim.keymap.set("n", "<leader>fr", function()
  Snacks.picker.recent()
end, { desc = "Recent" })
vim.keymap.set("n", "<leader>fg", function()
  local opts = { hidden = true }
  opts = handle_oil_dir(opts)
  Snacks.picker.grep(opts)
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>fG", function()
  local opts = { ignored = true, hidden = true }
  opts = handle_oil_dir(opts)
  Snacks.picker.grep(opts)
end, { desc = "Grep - All" })
vim.keymap.set("n", "<leader>fhg", function()
  local opts = { hidden = false }
  opts = handle_oil_dir(opts)
  Snacks.picker.grep(opts)
end, { desc = "Grep - No hidden" })
vim.keymap.set("n", "<leader>fs", function()
  Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>fS", function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })
vim.keymap.set({ "n", "x" }, "<leader>fw", function()
  Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })
vim.keymap.set("n", "<leader>fx", function()
  Snacks.picker()
end, { desc = "Find picker" })
vim.keymap.set("n", "<leader>fk", function()
  Snacks.picker.keymaps()
end, { desc = "Find keymaps" })
-- bufdelete
vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
  on_buf_delete()
end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", function()
  Snacks.bufdelete({ force = true })
end, { desc = "Delete buffer (force)" })
vim.keymap.set("n", "<leader>ba", function()
  Snacks.bufdelete.all()
  on_buf_delete()
end, { desc = "Delete buffers - all" })
vim.keymap.set("n", "<leader>bA", function()
  Snacks.bufdelete.all({ force = true })
  on_buf_delete()
end, { desc = "Delete buffers - all (force)" })
vim.keymap.set("n", "<leader>bo", function()
  Snacks.bufdelete.other()
  on_buf_delete()
end, { desc = "Delete buffers - others" })
vim.keymap.set("n", "<leader>bO", function()
  Snacks.bufdelete.other({ force = true })
  on_buf_delete()
end, { desc = "Delete buffers - others (force)" })
-- notifier
vim.keymap.set("n", "<leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Hide notifications" })
