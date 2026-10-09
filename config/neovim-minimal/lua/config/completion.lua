local M = {}

function M.setup()
	-- Mimic blink.cmp behavior: show menu, preselect but don't auto-insert
	vim.opt.completeopt = "menu,menuone,noselect,noinsert"

	-- Completion menu navigation (mimic blink.cmp)
	vim.keymap.set("i", "<C-y>", function()
		if vim.fn.pumvisible() == 1 then
			return "<C-y>"
		end
		return "<C-y>"
	end, { expr = true, silent = true, desc = "Completion: Accept" })

	vim.keymap.set("i", "<C-e>", function()
		if vim.fn.pumvisible() == 1 then
			return "<C-e>"
		end
		return "<C-e>"
	end, { expr = true, silent = true, desc = "Completion: Close" })

	vim.keymap.set("i", "<C-n>", function()
		if vim.fn.pumvisible() == 1 then
			return "<C-n>"
		end
		return "<Down>"
	end, { expr = true, silent = true, desc = "Completion: Next" })

	vim.keymap.set("i", "<C-p>", function()
		if vim.fn.pumvisible() == 1 then
			return "<C-p>"
		end
		return "<Up>"
	end, { expr = true, silent = true, desc = "Completion: Prev" })

	vim.keymap.set("i", "<Down>", "<C-n>", { silent = true, desc = "Completion: Next" })
	vim.keymap.set("i", "<Up>", "<C-p>", { silent = true, desc = "Completion: Prev" })

	-- Manual trigger LSP completion
	vim.keymap.set("i", "<C-Space>", function()
		vim.lsp.completion.get()
	end, { silent = true, desc = "LSP: Trigger completion" })

	-- vim.snippet support (Neovim built-in) - mimic blink.cmp Tab/S-Tab
	if vim.snippet then
		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if vim.snippet.active({ direction = 1 }) then
				vim.snippet.jump(1)
				return
			end
			return "<Tab>"
		end, { expr = true, silent = true, desc = "Snippet: Jump next" })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			if vim.snippet.active({ direction = -1 }) then
				vim.snippet.jump(-1)
				return
			end
			return "<S-Tab>"
		end, { expr = true, silent = true, desc = "Snippet: Jump prev" })
	end
end

return M