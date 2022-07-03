return {
  filetypes = { "markdown" },
  init_options = { documentFormatting = false },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      markdown = {
        {
          lintCommand = "markdownlint -s",
          lintStdin = true,
          lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" }
        }
      }
    }
  }
}
