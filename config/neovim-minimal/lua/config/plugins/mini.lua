local M = {}

function M.setup()
	-- mini.surround
	require("mini.surround").setup()

	-- mini.hipatterns
	require("mini.hipatterns").setup()

	-- mini.files
	local files = require("mini.files")
	files.setup()

	vim.keymap.set("n", "\\", function()
		files.open()
	end, { desc = "Toggle mini file explorer" })
	vim.keymap.set("n", "\\\\", function()
		files.open(vim.api.nvim_buf_get_name(0), false)
		files.reveal_cwd()
	end, { desc = "Open at current file" })

	-- mini.misc (zoom)
	local misc = require("mini.misc")
	misc.setup()

	vim.keymap.set("n", "<leader>az", function()
		misc.zoom()
	end, { desc = "Zoom window" })

	-- mini.comment (with <leader>c mapping)
	require("mini.comment").setup({
		mappings = {
			comment = "<leader>c",
			comment_line = "<leader>c",
			comment_visual = "<leader>c",
			textobject = "<leader>c",
		},
	})

	-- mini.trailspace
	local trailspace = require("mini.trailspace")
	trailspace.setup({ only_in_normal_buffers = true })

	vim.keymap.set("n", "<leader>tw", function()
		trailspace.trim()
	end, { desc = "Erase Whitespace" })

	vim.api.nvim_create_autocmd("CursorMoved", {
		pattern = "*",
		callback = function()
			require("mini.trailspace").unhighlight()
		end,
	})

	-- mini.splitjoin
	local splitjoin = require("mini.splitjoin")
	splitjoin.setup({ mappings = { toggle = "" } })

	vim.keymap.set({ "n", "x" }, "<leader>sj", function()
		splitjoin.join()
	end, { desc = "Join arguments" })
	vim.keymap.set({ "n", "x" }, "<leader>sk", function()
		splitjoin.split()
	end, { desc = "Split arguments" })
end

return M
