return {
	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Tokyonight colors for transparent theme
			local colors = {
				blue = "#7aa2f7",
				green = "#9ece6a",
				magenta = "#bb9af7",
				red = "#f7768e",
				yellow = "#e0af68",
				cyan = "#7dcfff",
				fg = "#c0caf5",
				gray = "#565f89",
			}

			-- Custom transparent theme
			local transparent_theme = {
				normal = {
					a = { fg = colors.blue, bg = "NONE", gui = "bold" },
					b = { fg = colors.cyan, bg = "NONE" },
					c = { fg = colors.fg, bg = "NONE" },
				},
				insert = {
					a = { fg = colors.green, bg = "NONE", gui = "bold" },
					b = { fg = colors.cyan, bg = "NONE" },
					c = { fg = colors.fg, bg = "NONE" },
				},
				visual = {
					a = { fg = colors.magenta, bg = "NONE", gui = "bold" },
					b = { fg = colors.cyan, bg = "NONE" },
					c = { fg = colors.fg, bg = "NONE" },
				},
				replace = {
					a = { fg = colors.red, bg = "NONE", gui = "bold" },
					b = { fg = colors.cyan, bg = "NONE" },
					c = { fg = colors.fg, bg = "NONE" },
				},
				command = {
					a = { fg = colors.yellow, bg = "NONE", gui = "bold" },
					b = { fg = colors.cyan, bg = "NONE" },
					c = { fg = colors.fg, bg = "NONE" },
				},
				inactive = {
					a = { fg = colors.gray, bg = "NONE" },
					b = { fg = colors.gray, bg = "NONE" },
					c = { fg = colors.gray, bg = "NONE" },
				},
			}

			local mode = {
				"mode",
				fmt = function(str)
					return " " .. str
				end,
			}

			local filename = {
				"filename",
				file_status = true,
				path = 0,
			}

			local hide_in_width = function()
				return vim.fn.winwidth(0) > 100
			end

			local diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
				colored = true,
				update_in_insert = true,
				always_visible = true,
			}

			local diff = {
				"diff",
				colored = true,
				symbols = { added = " ", modified = " ", removed = " " },
				cond = hide_in_width,
			}

			-- Make statusline background fully transparent
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = "│",
					section_separators = "",
					disabled_filetypes = { "alpha", "neo-tree" },
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { filename },
					lualine_x = {
						diagnostics,
						diff,
						{ "encoding", cond = hide_in_width },
						{ "filetype", cond = hide_in_width },
					},
					lualine_y = { "location" },
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
