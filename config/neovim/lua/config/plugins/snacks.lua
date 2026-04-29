return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesActionRename",
			callback = function(event)
				Snacks.rename.on_rename_file(event.data.from, event.data.to)
			end,
		})

		-- vim.api.nvim_create_autocmd("LspProgress", {
		-- 	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
		-- 	callback = function(ev)
		-- 		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		-- 		vim.notify(vim.lsp.status(), "info", {
		-- 			id = "lsp_progress",
		-- 			title = "LSP Progress",
		-- 			opts = function(notif)
		-- 				notif.icon = ev.data.params.value.kind == "end" and " "
		-- 					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
		-- 			end,
		-- 		})
		-- 	end,
		-- })
	end,
	keys = {
		{
			"<leader>qa",
			function()
				Snacks.bufdelete()
			end,
			desc = "Buffer delete",
			mode = "n",
		},
		{
			"<leader>qA",
			function()
				Snacks.bufdelete.all()
			end,
			desc = "Buffer delete all",
			mode = "n",
		},
		{
			"<leader>qo",
			function()
				Snacks.bufdelete.other()
			end,
			desc = "Buffer delete other",
			mode = "n",
		},

		{
			"<leader>fn",
			function()
				Snacks.notifier.show_history()
			end,
			{ desc = "[ ] Noice log" },
		},

		{
			"<leader>lg",
			function()
				require("snacks").lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				require("snacks").lazygit.log()
			end,
			desc = "Lazygit Logs",
		},

		{
			"<leader>pk",
			function()
				require("snacks").picker.keymaps({ layout = "ivy" })
			end,
			desc = "Search Keymaps (Snacks Picker)",
		},

		-- Git Stuff
		{
			"<leader>gbr",
			function()
				require("snacks").picker.git_branches({ layout = "select" })
			end,
			desc = "Pick and Switch Git Branches",
		},

		-- Other Utils
		{
			"<leader>th",
			function()
				require("snacks").picker.colorschemes({ layout = "ivy" })
			end,
			desc = "Pick Color Schemes",
		},
		{
			"<leader>ee",
			function()
				require("snacks").explorer.open()
			end,
			desc = "Open snacks explorer",
		},
	},
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
		explorer = { enabled = true },
		indent = {
			priority = 1,
			enabled = true,
			char = "│",
			only_scope = false,
			only_current = false,
			hl = "SnacksIndent",
			animate = {
				enabled = false,
			},
		},
		scope = { enabled = false },
		input = { enabled = false },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		rename = { enabled = true },
		zen = { enabled = false },
		image = { enabled = true },
	},
}
