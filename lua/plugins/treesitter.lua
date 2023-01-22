return {
  {
    'nvim-treesitter/playground',
    cmd = "TSPlaygroundToggle",
    opts = true,
  },
  {
    "ziontee113/syntax-tree-surfer",
    cmd = { "STSSelectMasterNode", "STSSelectCurrentNode" },
    keys = {
      -- Normal Mode Swapping:
      -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
      { "vU", function()
        vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
        return "g@l"
      end },
      { "vD", function()
        vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
        return "g@l"
      end },
      -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
      { "vd", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
        return "g@l"
      end },
      { "vu", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
        return "g@l"
      end },
      -- Visual Selection from Normal Mode
      { "vx", '<cmd>STSSelectMasterNode<cr>' },
      { "vn", '<cmd>STSSelectCurrentNode<cr>' },
      -- Select Nodes in Visual Mode
      { "J", '<cmd>STSSelectNextSiblingNode<cr>', mode = "x" },
      { "K", '<cmd>STSSelectPrevSiblingNode<cr>', mode = "x" },
      { "H", '<cmd>STSSelectParentNode<cr>', mode = "x" },
      { "L", '<cmd>STSSelectChildNode<cr>', mode = "x" },
      -- Swapping Nodes in Visual Mode
      { "<A-j>", '<cmd>STSSwapNextVisual<cr>', mode = "x" },
      { "<A-k>", '<cmd>STSSwapPrevVisual<cr>', mode = "x" },
    },
    opts = true,
  },
}
