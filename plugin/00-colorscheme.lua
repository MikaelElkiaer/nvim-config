vim.pack.add({
  {
    src = "https://github.com/sainnhe/gruvbox-material",
    version = "master",
  },
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  desc = "Avoid overwritten by loading color schemes later",
  callback = function()
    -- Align with heirline.nvim and gitmux
    vim.api.nvim_set_hl(0, "MiniDiffSignChange", {
      link = "DiagnosticWarn",
    })
    -- Dark background for floating windows
    vim.api.nvim_set_hl(0, "NormalFloat", {
      link = "Normal",
    })
    -- Transparent background for floating windows
    vim.api.nvim_set_hl(0, "FloatBorder", {
      bg = "none",
    })
    -- Make selections visible
    vim.api.nvim_set_hl(0, "WayfinderSelection", {
      link = "TabLine",
    })
    vim.api.nvim_set_hl(0, "WayfinderSelectionLabel", {
      link = "TabLine",
    })
    vim.api.nvim_set_hl(0, "WayfinderPreviewTarget", {
      link = "TabLine",
    })
    vim.api.nvim_set_hl(0, "WayfinderSelectionMuted", {
      link = "TabLine",
    })
    vim.api.nvim_set_hl(0, "WayfinderSelectionAccent", {
      link = "TabLine",
    })
    vim.api.nvim_set_hl(0, "WayfinderSelectionPath", {
      link = "TabLine",
    })
  end,
})

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_disable_italic_comment = true
vim.g.gruvbox_material_transparent_background = 1
vim.cmd.colorscheme("gruvbox-material")
