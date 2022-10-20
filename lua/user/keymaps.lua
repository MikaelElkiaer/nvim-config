-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Navigate buffers
keymap("n", "gk", ":bnext<CR>", opts)
keymap("n", "gj", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<leader>c", "<cmd>Bdelete!<CR>", opts)
keymap("n", "<leader>C", "<cmd>bufdo :Bdelete<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files hidden=true<CR>", opts)
keymap("n", "<leader>ft", ":lua require'telescope.builtin'.live_grep({ additional_args = function(opts) return {'--hidden'} end})<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current(nil, {})<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)
keymap("n", "<leader>dk", "<cmd>lua require('dap.ui.widgets').hover()<cr>", opts)

-- MikaelElkiaer
keymap("n", "<leader>fF", ":Telescope find_files hidden=true no_ignore=true<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fG", ":lua require'telescope.builtin'.live_grep({ additional_args = function(opts) return {'--hidden', '--no-ignore'} end})<CR>", opts)
keymap("n", "<leader>fo", ":Telescope oldfiles only_cwd=true<CR>", opts)
keymap("n", "<leader>fO", ":Telescope oldfiles<CR>", opts)
keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", opts)
keymap("n", "<leader>fS", ":Telescope lsp_workspace_symbols<CR>", opts)
keymap("n", "<leader>fl", ":Telescope file_browser path=%:p:h initial_mode=normal hidden=true respect_gitignore=false<CR>", opts)
keymap("n", "<leader>fL", ":Telescope file_browser initial_mode=normal hidden=true respect_gitignore=false<CR>", opts)
keymap("n", "<leader>fp", ":Telescope reprosjession root_dir=" .. vim.loop.os_homedir() .. "/Repositories<CR>", opts)

-- TUIs
keymap("n", "<leader><leader>g", "<cmd>lua require'toggleterm.terminal'.Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' }):toggle()<CR>", opts)
keymap("n", "<leader><leader>d", "<cmd>lua require'toggleterm.terminal'.Terminal:new({ cmd = 'lazydocker', hidden = true, direction = 'float', dir='%:p:h' }):toggle()<CR>", opts)
keymap("n", "<leader><leader><cr>", "<cmd>ToggleTerm<CR>", opts)

-- vim-test
keymap("n", "<leader>tn", "<cmd>TestNearest<CR>", opts)
keymap("n", "<leader>tf", "<cmd>TestFile<CR>", opts)
keymap("n", "<leader>ts", "<cmd>TestSuite<CR>", opts)
keymap("n", "<leader>tl", "<cmd>TestLast<CR>", opts)
keymap("n", "<leader>tv", "<cmd>TestVisit<CR>-\\><C-n><C-w>l", opts)

-- Normal Mode Swapping:
-- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vU", function()
	vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })
vim.keymap.set("n", "vD", function()
	vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })

-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vd", function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })
vim.keymap.set("n", "vu", function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })

--> If the mappings above don't work, use these instead (no dot repeatable)
-- vim.keymap.set("n", "vd", '<cmd>STSSwapCurrentNodeNextNormal<cr>', opts)
-- vim.keymap.set("n", "vu", '<cmd>STSSwapCurrentNodePrevNormal<cr>', opts)
-- vim.keymap.set("n", "vD", '<cmd>STSSwapDownNormal<cr>', opts)
-- vim.keymap.set("n", "vU", '<cmd>STSSwapUpNormal<cr>', opts)

-- Visual Selection from Normal Mode
vim.keymap.set("n", "vx", '<cmd>STSSelectMasterNode<cr>', opts)
vim.keymap.set("n", "vn", '<cmd>STSSelectCurrentNode<cr>', opts)

-- Select Nodes in Visual Mode
vim.keymap.set("x", "J", '<cmd>STSSelectNextSiblingNode<cr>', opts)
vim.keymap.set("x", "K", '<cmd>STSSelectPrevSiblingNode<cr>', opts)
vim.keymap.set("x", "H", '<cmd>STSSelectParentNode<cr>', opts)
vim.keymap.set("x", "L", '<cmd>STSSelectChildNode<cr>', opts)

-- Swapping Nodes in Visual Mode
vim.keymap.set("x", "<A-j>", '<cmd>STSSwapNextVisual<cr>', opts)
vim.keymap.set("x", "<A-k>", '<cmd>STSSwapPrevVisual<cr>', opts)

-- rest-nvim
vim.keymap.set('n', '<leader>rh', '<cmd>lua require("rest-nvim").run()<cr>', opts)
vim.keymap.set('n', '<leader>rph', '<cmd>lua require("rest-nvim").run(true)<cr>', opts)

-- run code and codi
vim.keymap.set('n', '<leader>rcf', '<cmd>RunCodeFile<cr>', opts)
vim.keymap.set('n', '<leader>rcb', '<cmd>RunCodeBlock<cr>', opts)
vim.keymap.set('n', '<leader>rcs', '<cmd>RunCodeSelected<cr>', opts)
vim.keymap.set('n', '<leader>rC', '<cmd>Codi<cr>', opts)
