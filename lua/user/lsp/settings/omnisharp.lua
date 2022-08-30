return {
  filetypes = { "cs", "csx" },
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  cmd = { "/usr/bin/omnisharp" },
  root_dir = function(fname)
    if fname:sub(- #".csx") == ".csx" then
      return require('lspconfig').util.path.dirname(fname)
    end
    return vim.fn.getcwd()
  end
}
