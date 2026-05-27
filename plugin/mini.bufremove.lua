vim.pack.add({
  {
    src = "https://github.com/nvim-mini/mini.bufremove",
    version = "main",
  },
})

require("mini.bufremove").setup()

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

vim.keymap.set("n", "<leader>bd", function(...)
  require("mini.bufremove").wipeout(...)
  on_buf_delete()
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>bD", function(...)
  require("mini.bufremove").wipeout(..., true)
  on_buf_delete()
end, { desc = "Delete Buffer (Force)" })

vim.keymap.set("n", "<leader>ba", function()
  vim.cmd("bufdo bwipeout")
  on_buf_delete()
end, { desc = "Delete buffers - All" })

vim.keymap.set("n", "<leader>bA", function()
  vim.cmd("bufdo bwipeout!")
  on_buf_delete()
end, { desc = "Delete buffers - All (Force)" })

vim.keymap.set("n", "<leader>bo", function()
  vim.cmd(":execute 'bufdo if bufnr() != ' . bufnr('%') . ' | bwipeout | endif'")
  on_buf_delete()
end, { desc = "Delete buffers - Others" })

vim.keymap.set("n", "<leader>bO", function()
  vim.cmd(":execute 'bufdo if bufnr() != ' . bufnr('%') . ' | bwipeout! | endif'")
  on_buf_delete()
end, { desc = "Delete buffers - Others (Force)" })
