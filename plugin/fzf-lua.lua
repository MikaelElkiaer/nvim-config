vim.pack.add({
  {
    src = "https://github.com/ibhagwan/fzf-lua",
    version = "main",
  },
})

local function open_oil(items, _)
  local has_oil, oil = pcall(require, "oil")
  if not has_oil then
    vim.notify("No oil.nvim found, unable to open file explorer", vim.log.levels.WARN)
  end

  if #items > 1 then
    vim.notify("Multiple items selected, unable to open file explorer", vim.log.levels.WARN)
    return
  end

  local fzf_path = require("fzf-lua.path")
  local file = fzf_path.entry_to_file(items[1])
  local path = vim.fn.fnamemodify(file.path, ":h")

  vim.notify("Opening oil.nvim in " .. path)

  oil.open(path)
end

require("fzf-lua").setup({
  winopts = {
    split = "belowright new",
  },
  fzf_opts = {
    ["--layout"] = "reverse",
  },
  ui_select = true,
  defaults = {
    actions = {
      ["ctrl-o"] = { fn = open_oil },
    },
  },
  grep = {
    hidden = true,
    rg_opts = '-g "!.git" -g "!.jj" --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
  },
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
})

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

  return vim.tbl_deep_extend("force", opts or {}, { cwd = dir })
end

vim.keymap.set("n", "<leader><space>", function()
  require("fzf-lua").global()
end, { desc = "Global Search" })

vim.keymap.set("n", "<leader>fl", function()
  require("fzf-lua").lsp_finder()
end, { desc = "LSP Finder" })

vim.keymap.set("n", "<leader>fb", function()
  require("fzf-lua").buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>ff", function()
  local opts = handle_oil_dir()
  require("fzf-lua").files(opts)
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fr", function()
  require("fzf-lua").oldfiles()
end, { desc = "Recent" })

vim.keymap.set("n", "<leader>fg", function()
  local opts = handle_oil_dir()
  require("fzf-lua").live_grep(opts)
end, { desc = "Grep" })

vim.keymap.set("n", "<leader>fs", function()
  require("fzf-lua").lsp_document_symbols()
end, { desc = "LSP Symbols" })

vim.keymap.set("n", "<leader>fS", function()
  require("fzf-lua").lsp_live_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })

vim.keymap.set("n", "<leader>fw", function()
  require("fzf-lua").grep_cword()
end, { desc = "Grep word under cursor" })

vim.keymap.set("x", "<leader>fw", function()
  require("fzf-lua").grep_visual()
end, { desc = "Grep visual selection" })

vim.keymap.set("n", "<leader>fx", function()
  require("fzf-lua").builtin()
end, { desc = "Find picker" })
