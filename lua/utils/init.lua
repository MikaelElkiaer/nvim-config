local M = {}

M._terms = {}
M._keymap_groups = {}

M.create_tui = function(self, cmd)
  local toggleterm = require("toggleterm.terminal")
  local dir = vim.fn.getcwd()
  local c = self._terms[cmd] or {}
  c[dir] = c[dir]
    or toggleterm.Terminal:new({
      cmd = cmd,
      dir = dir,
      direction = "float",
      hidden = true,
      -- on_open = function(term)
      --   vim.cmd("startinsert!")
      --   -- stylua: ignore
      --   -- Override q to keep TUI process alive
      --   vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", '<cmd>close<cr>', { noremap = true, silent = true })
      -- end,
      -- on_close = function(_)
      --   vim.cmd("startinsert!")
      -- end,
    })
  c[dir]:toggle()
  self._terms[cmd] = c
end

M.create_keymap_group = function(self, key, name)
  self._keymap_groups = self._keymap_groups or {}
  table.insert(self._keymap_groups, {
    key,
    group = name,
  })
end

M.get_keymap_groups = function(self)
  return self._keymap_groups
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
