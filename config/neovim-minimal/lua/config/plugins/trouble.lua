local M = {}

function M.setup()
	require("trouble").setup({})

	local map = vim.keymap.set
	map("n", "<leader>tp", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
	map("n", "<leader>tP", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
	map("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
	map("n", "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions/references (Trouble)" })
	map("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
	map("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
end

return M
