return {
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox" },
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "neo-tree.nvim",
    enabled = false,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Disable snippets in completion
      { "saadparwaiz1/cmp_luasnip", enabled = false },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      {
        "zbirenbaum/copilot-cmp",
        opts = {},
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")

      -- Disable auto selection of first item in completion
      opts.completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      })

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "copilot" },
        { name = "nvim_lsp_signature_help" },
      }))

      cmp.event:on("menu_opened", function()
        vim.api.nvim_create_autocmd("InsertCharPre", {
          callback = function(_)
            if (cmp.get_selected_entry()) ~= nil then
              local c = vim.v.char
              vim.v.char = ""
              vim.schedule(function()
                cmp.confirm({ select = false })
                vim.api.nvim_feedkeys(c, "n", false)
              end)
            end
          end,
          once = true,
        })
      end)
    end,
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "echasnovski/mini.surround",
    enabled = false,
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  {
    "catppuccin/nvim",
    enabled = false,
    name = "catppuccin",
  },
}
