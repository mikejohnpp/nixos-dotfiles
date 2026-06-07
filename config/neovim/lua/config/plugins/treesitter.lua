return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		opts = {
			ensure_installed = {
				"java",
				"c",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"python",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"regex",
				"json",
				"yaml",
				"bash",
				"php",
				"blade",
				"vue",
			},
			auto_install = false,
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 kb
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},
		},
	},
}
