return {
  "ggandor/leap.nvim",
  config = function()
    do
      -- Returns an argument table for `leap()`, tailored for f/t-motions.
      local function as_ft(key_specific_args)
        local common_args = {
          inputlen = 1,
          inclusive = true,
          -- To limit search scope to the current line:
          -- pattern = function (pat) return '\\%.l'..pat end,
          opts = {
            labels = "", -- force autojump
            safe_labels = vim.fn.mode(1):match("o") and "" or nil, -- [1]
            case_sensitive = true, -- [2]
          },
        }
        return vim.tbl_deep_extend("keep", common_args, key_specific_args)
      end

      local clever = require("leap.user").with_traversal_keys -- [3]
      local clever_f = clever("f", "F")
      local clever_t = clever("t", "T")

      for key, args in pairs({
        f = { opts = clever_f },
        F = { backward = true, opts = clever_f },
        t = { offset = -1, opts = clever_t },
        T = { backward = true, offset = 1, opts = clever_t },
      }) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          require("leap").leap(as_ft(args))
        end)
      end
    end

    ------------------------------------------------------------------------
    -- [1] Match the modes here for which you don't want to use labels
    --     (`:h mode()`, `:h lua-pattern`).
    -- [2] For 1-char search, you might want to aim for precision instead of
    --     typing comfort, to get as many direct jumps as possible.
    -- [3] This helper function makes it easier to set "clever-f"-like
    --     functionality (https://github.com/rhysd/clever-f.vim), returning
    --     an `opts` table derived from the defaults, where:
    --     * the given keys are added to `keys.next_target` and
    --       `keys.prev_target`
    --     * the forward key is used as the first label in `safe_labels`
    --     * the backward (reverse) key is removed from `safe_labels`
  end,
  dependencies = {
    "tpope/vim-repeat",
  },
  keys = {
    { "s", "<Plug>(leap-forward)", desc = "leap", mode = { "n", "x", "o" } },
    { "S", "<Plug>(leap-backward)", desc = "leap backward", mode = { "n", "x", "o" } },
  },
  lazy = false,
}
