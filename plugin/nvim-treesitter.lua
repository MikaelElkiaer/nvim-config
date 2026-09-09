vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
})

-- source: https://github.com/MeanderingProgrammer/treesitter-modules.nvim
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter.setup", {}),
  callback = function(args)
    local buf = args.buf
    local filetype = args.match

    -- you need some mechanism to avoid running on buffers that do not
    -- correspond to a language (like oil.nvim buffers), this implementation
    -- checks if a parser exists for the current language
    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if not vim.treesitter.language.add(language) then
      return
    end

    -- replicate `fold = { enable = true }`
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    -- replicate `highlight = { enable = true }`
    vim.treesitter.start(buf, language)

    -- replicate `indent = { enable = true }`
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    -- `incremental_selection = { enable = true }` covered by 0.12.0
  end,
})

-- Support for tmux was removed
-- - see https://github.com/nvim-treesitter/nvim-treesitter/commit/78bebef150057eff7f26044bb177fbbf82ff047d
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").tmux = {
      tier = 0,
      install_info = {
        url = "https://github.com/Freed-Wu/tree-sitter-tmux",
        revision = "58147321fa1f00daec15dd4d371bc9e2e9373459", -- commit hash for revision to check out; HEAD if missing
        -- optional entries:
        -- branch = 'develop', -- only needed if different from default branch
        -- location = 'parser', -- only needed if the parser is in subdirectory of a "monorepo"
        generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
        generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
        queries = "queries", -- also install queries from given directory
      },
    }
  end,
})
