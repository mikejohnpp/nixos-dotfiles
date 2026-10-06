-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Hey! Put lazy into the runtimepath for neovim!
vim.opt.runtimepath:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Provides the build toolchain (luv library, C compiler) used by plugins
		-- that compile native code. Must come first so it is installed before
		-- anything that needs to build.
		{ "folke/lazydev.nvim", priority = 10000 },
		{ "tpope/vim-sleuth" },
		-- Highlight todo, notes, etc in comments
		{
			"folke/todo-comments.nvim",
			event = "VimEnter",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = { signs = false },
		},
		{
			"saecki/crates.nvim",
			tag = "stable",
			event = { "BufRead Cargo.toml" },
			config = function()
				require("crates").setup()
			end,
		},
		{ import = "config.plugins" },
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = false, -- get a notification when changes are found
	},
})
