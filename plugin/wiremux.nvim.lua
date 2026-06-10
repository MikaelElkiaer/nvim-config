vim.pack.add({
  {
    src = "https://github.com/MSmaili/wiremux.nvim",
    version = "main",
  },
})

require("wiremux").setup({
  picker = { adapter = "fzf-lua" },
  targets = {
    definitions = {
      -- AI assistants
      copilot = { cmd = "copilot", kind = { "pane", "window" }, shell = false },
      gemini = { cmd = "gemini", kind = { "pane", "window" }, shell = false },
      -- Interactive shell
      shell = { kind = { "pane", "window" }, shell = true },
      -- Quick command runner
      quick = { kind = { "pane", "window" }, shell = false },
    },
  },
})

vim.keymap.set("n", "<leader>aa", function()
  require("wiremux").toggle()
end, { desc = "Toggle target" })

vim.keymap.set("n", "<leader>ac", function()
  require("wiremux").create()
end, { desc = "Create target" })

-- Send context
vim.keymap.set("n", "<leader>af", function()
  require("wiremux").send("{file}")
end, { desc = "Send file" })

vim.keymap.set({ "x", "n" }, "<leader>at", function()
  require("wiremux").send("{this}")
end, { desc = "Send this" })

vim.keymap.set("x", "<leader>av", function()
  require("wiremux").send("{selection}")
end, { desc = "Send selection" })

vim.keymap.set("n", "<leader>ad", function()
  require("wiremux").send("{diagnostics}")
end, { desc = "Send diagnostics" })

-- Send motion (works like an operator: ga + motion, e.g. gaip sends a paragraph)
vim.keymap.set("n", "ga", function()
  require("wiremux").send_motion()
end, { desc = "Send motion to target" })

-- AI prompts picker
vim.keymap.set({ "n", "x" }, "<leader>ap", function()
  require("wiremux").send({
    { label = "Review changes", value = "Can you review my changes?\n{changes}" },
    {
      label = "Fix diagnostics",
      value = "Can you help me fix this?\n{diagnostics}",
      visible = function()
        return require("wiremux.context").is_available("diagnostics")
      end,
    },
    { label = "Explain", value = "Explain {this}" },
    { label = "Write tests", value = "Can you write tests for {this}?" },
  })
end, { desc = "AI prompts" })
