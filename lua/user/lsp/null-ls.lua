local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local diagnostics_hush = h.make_builtin({
  name = "hush",
  meta = {
    url = "https://github.com/hush-shell/hush",
    description = "Using hush to do static checking",
  },
  method = DIAGNOSTICS,
  filetypes = { "hush" },
  generator_opts = {
    command = "hush",
    args = { "--check" },
    to_stdin = true,
    from_stderr = true,
    format = "line",
    check_exit_code = function(code)
      return code <= 1
    end,
    -- Example:
    -- Error: <stdin> (line 3, column 0) - undeclared variable 'et'
    on_output = h.diagnostics.from_pattern('^(.*): .* %(line (%d+), column (%d+)%) %- (.*)$', { "severity", "row", "col", "message" }, { severities = { ["Error"] = 1 } })
  },
  factory = h.generator_factory,
})

null_ls.setup {
  debug = false,
  sources = {
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.diagnostics.shellcheck,
    diagnostics_hush,
  },
}
