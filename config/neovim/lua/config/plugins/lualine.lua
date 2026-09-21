return {
	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local mode = {
				"mode",
				fmt = function(str)
					return " " .. str
					-- return " " .. str:sub(1, 1) -- displays only the first character of the mode
					-- return str
				end,
			}
			local filename = {
				"filename",
				file_status = true,
				path = 0,
			}

			local hide_in_width = function()
				-- return vim.fn.winwidth(0) > 100
				return true
			end

			local diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
				colored = true,
				update_in_insert = true,
				always_visible = true,
			}

			local diff = {
				"diff",
				colored = true,
				symbols = {
					added = "󰐕 ",
					modified = "󰏫 ",
					removed = "󰍴 ",
				},
				cond = hide_in_width,
			}

			-- Make statusline background fully transparent
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					-- component_separators = "│",
					-- section_separators = "",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					disabled_filetypes = { "alpha", "neo-tree" },
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { mode },
					lualine_b = { { "branch", icon = "" }, { "filetype", cond = hide_in_width } },
					lualine_c = {
						filename,
					},

					lualine_x = {
						diff,
						diagnostics,
						{
							"lsp_status",
							ignore_lsp = { "null-ls", "copilot" },
							symbols = { done = "" },
							cond = hide_in_width,
						},
						{ "encoding", cond = hide_in_width },
					},
					lualine_y = { "searchcount", "location" },
					lualine_z = { "progress" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { { "location", padding = 0 } },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "nvim-tree", "nvim-dap-ui", "quickfix", "trouble" },
			})
		end,
	},
}
