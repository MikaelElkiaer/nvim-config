return {
  cmd = { "yaml-schema-router" },
  settings = {
    yaml = {
      customTags = {
        "!override mapping",
        "!override scalar",
        "!override sequence",
        "!reset mapping",
        "!reset scalar",
        "!reset sequence",
      },
    },
  },
}
