local M = {}

M.create_keymap_group = function(key, name, mode)
  local success, wk = pcall(require, "which-key")
  if not success then return end
  wk.register({
    mode = mode or { "n", "v" },
    [key] = { name = name },
  })
end

return M
