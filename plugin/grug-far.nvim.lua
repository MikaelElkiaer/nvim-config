vim.pack.add({
  {
    src = "https://github.com/MagicDuck/grug-far.nvim",
    version = "main",
  },
})

require("grug-far").setup({})

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

  return vim.tbl_deep_extend("force", opts or {}, { paths = dir })
end

vim.keymap.set({ "n", "x" }, "<leader>G", function()
  local prefills = handle_oil_dir()
  require("grug-far").open({ prefills = prefills, visualSelectionUsage = "auto-detect" })
end, { desc = "grug-far: Search within range" })
