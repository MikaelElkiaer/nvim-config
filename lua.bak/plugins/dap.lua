return {
  {
    "mfussenegger/nvim-dap",
    config = function(plugin, ...)
      plugin._.super.config(...)
      local dap = require("dap")
      dap.adapters.netcoredbg = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }
      require("dap.ext.vscode").load_launchjs(nil, { coreclr = { "cs" } })
    end,
  },
}
