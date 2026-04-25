local function move_yaml_smart(direction)
  local node = vim.treesitter.get_node()
  if not node then
    return
  end

  local function get_pair(n)
    while n and n:type() ~= "block_mapping_pair" do
      n = n:parent()
    end
    return n
  end

  local current = get_pair(node)
  if not current then
    return
  end

  local sr, sc, er, ec = current:range()
  local lines = vim.api.nvim_buf_get_lines(0, sr, er + 1, false)
  local bufnr = 0

  if direction == "parent" then
    -- PROMOTE: Move out of current nesting
    local parent_pair = get_pair(current:parent())
    if not parent_pair then
      return
    end -- Already at top level

    local psr, psc, _, _ = parent_pair:range()
    local parent_indent = string.rep(" ", psc)

    for i, line in ipairs(lines) do
      lines[i] = parent_indent .. line:gsub("^%s+", "")
    end

    vim.api.nvim_buf_set_lines(bufnr, sr, er + 1, false, {})
    vim.api.nvim_buf_set_lines(bufnr, psr, psr, false, lines)
    vim.api.nvim_win_set_cursor(0, { psr + 1, psc })
  elseif direction == "child" then
    -- DEMOTE: Move into the sibling BELOW if it's a container
    local next_sibling = current:next_named_sibling()
    if not next_sibling or next_sibling:type() ~= "block_mapping_pair" then
      return
    end

    -- Check if the sibling below has a block (nested) value
    -- In TS, this is usually the last child of the mapping_pair
    local value_node = next_sibling:field("value")[1]
    if not value_node or value_node:type() ~= "block_node" then
      vim.notify("Target is not a container", vim.log.levels.WARN)
      return
    end

    local _, nsc, ner, _ = next_sibling:range()
    local child_indent = string.rep(" ", nsc + vim.fn.shiftwidth())

    for i, line in ipairs(lines) do
      lines[i] = child_indent .. line:gsub("^%s+", "")
    end

    -- Remove current and insert as the first child of the sibling's block
    -- We insert at ner + 1 (the line after the sibling's key)
    vim.api.nvim_buf_set_lines(bufnr, sr, er + 1, false, {})
    vim.api.nvim_buf_set_lines(bufnr, ner + 1, ner + 1, false, lines)
    vim.api.nvim_win_set_cursor(0, { ner + 1, #child_indent })
  end
end

local function swap_yaml_siblings(direction)
  local node = vim.treesitter.get_node()
  local current = node
  while current and current:type() ~= "block_mapping_pair" do
    current = current:parent()
  end
  if not current then
    return
  end

  local target = (direction == "prev") and current:prev_named_sibling() or current:next_named_sibling()
  if not target or target:type() ~= "block_mapping_pair" then
    return
  end

  local sr1, sc1, er1, ec1 = current:range()
  local sr2, sc2, er2, ec2 = target:range()
  local text1 = vim.api.nvim_buf_get_text(0, sr1, sc1, er1, ec1, {})
  local text2 = vim.api.nvim_buf_get_text(0, sr2, sc2, er2, ec2, {})

  -- Perform swap and track new position
  if direction == "prev" then
    -- target is above current
    vim.api.nvim_buf_set_text(0, sr1, sc1, er1, ec1, text2)
    vim.api.nvim_buf_set_text(0, sr2, sc2, er2, ec2, text1)
    vim.api.nvim_win_set_cursor(0, { sr2 + 1, sc2 })
  else
    -- target is below current
    vim.api.nvim_buf_set_text(0, sr2, sc2, er2, ec2, text1)
    vim.api.nvim_buf_set_text(0, sr1, sc1, er1, ec1, text2)
    -- Since current moved to target's old position
    vim.api.nvim_win_set_cursor(0, { sr2 + 1, sc2 })
  end
end

local b = { buffer = true }
vim.keymap.set("n", "<M-h>", function()
  move_yaml_smart("parent")
end, b)
vim.keymap.set("n", "<M-j>", function()
  swap_yaml_siblings("next")
end, b)
vim.keymap.set("n", "<M-k>", function()
  swap_yaml_siblings("prev")
end, b)
vim.keymap.set("n", "<M-l>", function()
  move_yaml_smart("child")
end, b)
