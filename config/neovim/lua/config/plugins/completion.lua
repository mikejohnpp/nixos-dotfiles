return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<M-J>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				panel = { enabled = false },
			})
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = {
			-- Add a collection of common snippets (including HTML)
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					-- Optional: load custom snippets from a local directory
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})

					local ls = require("luasnip")
					ls.filetype_extend("typescriptreact", { "html" })
					ls.filetype_extend("javascriptreact", { "html" })
					ls.filetype_extend("typescript", { "javascript" })
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	{
		"saghen/blink.cmp",
		enabled = true,
		dependencies = {
			-- "xzbdmw/colorful-menu.nvim",
		},
		version = "v1.*",
		opts = {
			snippets = { preset = "luasnip" },
			fuzzy = {
				implementation = "prefer_rust",
			},
			keymap = {
				preset = "default",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "show_documentation", "hide", "fallback" },
				["<C-y>"] = { "accept", "fallback" },

				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				-- 'prefix' will fuzzy match on the text before the cursor
				-- 'full' will fuzzy match on the text before *and* after the cursor
				-- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
				keyword = { range = "full" },
			},
			cmdline = {
				enabled = true,
				keymap = { preset = "cmdline" },
				completion = {
					menu = { auto_show = true },
				},
			},
			sources = {
				default = { "lsp", "path", "buffer", "snippets" },
				providers = {
					lsp = {
						opts = {
							tailwind_color_icon = "󱓻",
						},
					},
				},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			signature = {
				enabled = true,
				window = {
					border = "rounded",
					winblend = 0,
				},
			},
			completion = {
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 500,
					window = {
						border = "rounded",
						winblend = 0,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon" },
							{ "label", gap = 1 },
							{ "kind" },
							{ "label_description", gap = 1 },
						},
						components = {
							label = {
								width = { fill = true, max = 60 },
								-- text = function(ctx)
								-- 	local highlights_info = require("colorful-menu").blink_highlights(ctx)
								-- 	if highlights_info ~= nil then
								-- 		-- Or you want to add more item to label
								-- 		return highlights_info.label
								-- 	else
								-- 		return ctx.label
								-- 	end
								-- end,
								-- highlight = function(ctx)
								-- 	local highlights = {}
								-- 	local highlights_info = require("colorful-menu").blink_highlights(ctx)
								-- 	if highlights_info ~= nil then
								-- 		highlights = highlights_info.highlights
								-- 	end
								-- 	for _, idx in ipairs(ctx.label_matched_indices) do
								-- 		table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								-- 	end
								-- 	-- Do something else
								-- 	return highlights
								-- end,
							},
						},
					},

					border = "rounded",
					winblend = 0,
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
			},
		},
	},
}
