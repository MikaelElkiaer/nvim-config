local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
  return
end

whichkey.setup { }

whichkey.register({
  d = {
    name = "DAP",
  },
}, { prefix = "<leader>" })

whichkey.register({
  f = {
    name = "Find",
  },
}, { prefix = "<leader>" })

whichkey.register({
  g = {
    name = "Term",
  },
}, { prefix = "<leader>" })

whichkey.register({
  l = {
    name = "LSP",
  },
}, { prefix = "<leader>" })

whichkey.register({
  t = {
    name = "Test",
  },
}, { prefix = "<leader>" })
