do
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

require("lazy").setup({
  -- automatically check for plugin updates
  checker = { enabled = false },
  defaults = {
    lazy = true,
    -- always use the latest git commit
    version = false,
  },
  dev = {
    path = "~/Repositories/GitHub",
    ---@type string[]
    patterns = {},
  },
  install = { colorscheme = { "gruvbox" } },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  spec = {
    { import = "plugins" },
  },
  ui = {
    border = "rounded",
  },
})
