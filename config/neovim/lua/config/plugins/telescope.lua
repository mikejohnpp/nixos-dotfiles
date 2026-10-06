return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"saghen/blink.cmp",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
	},
	{
		{
			"nvim-telescope/telescope-ui-select.nvim",
			config = function()
				-- get access to telescopes navigation functions
				local actions = require("telescope.actions")

				require("telescope").setup({
					defaults = {
						file_ignore_patterns = {
							"^node_modules/",
						},
						-- NOTE: this telescope version only reads `defaults`,
						-- `pickers` and `extensions` at the top level of setup().
						-- Neovim has no filetype for image formats, so the builtin
						-- previewer classifies them as binary and prints
						-- "Binary cannot be previewed". mime_hook is invoked exactly
						-- for binary files, so render those through Snacks.image.
						preview = {
							mime_hook = function(filepath, bufnr, opts)
								if Snacks.image.supports_file(filepath) and Snacks.image.supports_terminal() then
									vim.schedule(function()
										Snacks.image.buf.attach(bufnr, { src = filepath })
									end)
								else
									require("telescope.previewers.utils").set_preview_message(
										bufnr,
										opts.winid,
										"Binary cannot be previewed",
										opts.preview.msg_bg_fillchar
									)
								end
							end,
						},
					},
					-- use ui-select dropdown as our ui
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
					-- set keymappings to navigate through items in the telescope io
					mappings = {
						i = {
							-- use <cltr> + n to go to the next option
							["<C-n>"] = actions.cycle_history_next,
							-- use <cltr> + p to go to the previous option
							["<C-p>"] = actions.cycle_history_prev,
							-- use <cltr> + j to go to the next preview
							["<C-j>"] = actions.move_selection_next,
							-- use <cltr> + k to go to the previous preview
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				})

				-- extensions must be loaded AFTER setup(): the fzf extension
				-- overrides config.file_sorter / config.generic_sorter, which
				-- setup() would otherwise overwrite.
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("ui-select")
				require("telescope").load_extension("dap")
				-- require("telescope").load_extension("noice")

				vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
				vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
				vim.keymap.set(
					"n",
					"<leader>fw",
					require("telescope.builtin").grep_string,
					{ desc = "[S]earch current [W]ord" }
				)
				vim.keymap.set(
					"n",
					"<leader>fg",
					require("telescope.builtin").live_grep,
					{ desc = "[S]earch by [G]rep" }
				)
				vim.keymap.set(
					"n",
					"<leader>fd",
					require("telescope.builtin").diagnostics,
					{ desc = "[S]earch [D]iagnostics" }
				)
				vim.keymap.set("n", "<S-b>", function()
					require("telescope.builtin").buffers({
						sort_mru = true,
						sort_lastused = true,
						initial_mode = "normal",
						theme = "ivy",
						cwd_only = true,
					})
				end, { desc = "Find buffers in current tab" })

				vim.keymap.set(
					"n",
					"<leader>fs",
					require("telescope.builtin").current_buffer_fuzzy_find,
					{ desc = "Current fuzzy find" }
				)
				vim.keymap.set(
					"n",
					"<leader>fo",
					require("telescope.builtin").lsp_document_symbols,
					{ desc = "Document symbols" }
				)
				vim.keymap.set(
					"n",
					"<leader>fi",
					require("telescope.builtin").lsp_incoming_calls,
					{ desc = "Incoming calls" }
				)
				vim.keymap.set("n", "<leader>fW", function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols()
				end, { desc = "Workspace symbols" })
				vim.keymap.set("n", "<leader>fm", function()
					require("telescope.builtin").treesitter({ symbols = { "function", "method" } })
				end, { desc = "[F]ind [M]ethods in current class" }) -- fuzzy find methods in current class
			end,
		},
	},
}
