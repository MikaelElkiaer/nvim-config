local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = false,
	persist_size = true,
  persist_mode = false,
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>i", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>c", [[<C-\><C-n><C-W>c]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
local lazydocker = Terminal:new({ cmd = "lazydocker", hidden = true, direction = "float" })

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end

function _LAZYDOCKER_TOGGLE()
	lazydocker:toggle()
end
