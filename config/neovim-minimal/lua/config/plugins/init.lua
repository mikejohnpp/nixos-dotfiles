local M = {}

local core = require("config.plugins.core")
local extras = require("config.plugins.extras")
local mini = require("config.plugins.mini")
local trouble = require("config.plugins.trouble")

function M.setup()
	core.setup()
	extras.setup()
	mini.setup()
	trouble.setup()
end

return M
