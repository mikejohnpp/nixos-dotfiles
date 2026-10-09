local M = {}

function M.core()
	-- Core plugin packages via vim.pack (remote fetch when needed)
	vim.pack.add({
		{ name = "nvim-lspconfig", src = "https://github.com/neovim/nvim-lspconfig" },
	})
end

function M.setup()
	-- Setup order: core packages first, then LSP/completion
	M.core()
end

return M
