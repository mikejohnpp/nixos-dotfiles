local M = {}

function M.setup()
	vim.pack.add({
		{ name = "mini.nvim", src = "https://github.com/echasnovski/mini.nvim" },
		{ name = "trouble.nvim", src = "https://github.com/folke/trouble.nvim" },
		{ name = "vim-tmux-navigator", src = "https://github.com/christoomey/vim-tmux-navigator" },
	})
end

return M
