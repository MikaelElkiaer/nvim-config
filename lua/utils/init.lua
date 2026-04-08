local M = {}

M._keymap_groups = {}

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

return M
