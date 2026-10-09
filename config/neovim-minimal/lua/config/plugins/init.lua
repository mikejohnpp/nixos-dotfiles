local M = {}

local core = require("config.plugins.core")
local extras = require("config.plugins.extras")
local mini = require("config.plugins.mini")
local trouble = require("config.plugins.trouble")
local vim_tmux_navigator = require("config.plugins.vim-tmux-navigator")

function M.setup()
	core.setup()
	extras.setup()
	mini.setup()
	trouble.setup()
  	vim_tmux_navigator.setup()
end

return M
