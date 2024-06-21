local M = {}

M.create_keymap_group = function(key, name, mode)
  local success, wk = pcall(require, "which-key")
  if not success then
    return
  end
  wk.register({
    mode = mode or { "n", "v" },
    [key] = { name = name },
  })
end

M.on_buffer_delete = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
  if not is_empty then
    return
  end

  local orig_cwd = os.getenv("PWD")
  if orig_cwd ~= nil then
    vim.fn.chdir(orig_cwd)
  end
  -- WARN: Delete final buffer before opening dashboard
  vim.api.nvim_buf_delete(buf_id, {})
  require("dashboard"):instance()
end

return M
