local M = {}

-- Collection of subcommands exported by micro modules: name -> { command = handler }
---@type table<string, table<string, function>>
local subcommands = {}

--- Set up a micro module and register its subcommands.
---@param name string
---@param mod table
---@param config any
local function setup_module(name, mod, config)
	if mod.setup then
		mod.setup(config or {})
	end
	if mod.subcommands then
		for subname, handlers in pairs(mod.subcommands) do
			subcommands[subname] = handlers
		end
	end
end

--- Complete subcommand names for `:Micro`.
---@param arglead string
---@param cmdline string
---@return string[]
local function complete(arglead, cmdline)
	local args = vim.split(vim.trim(cmdline), "%s+")
	local pool

	if #args <= 1 then
		pool = subcommands
	else
		pool = subcommands[args[2]]
	end

	if not pool then
		return {}
	end

	local matches = {}
	for name in pairs(pool) do
		if name:match("^" .. vim.pesc(arglead)) then
			table.insert(matches, name)
		end
	end
	return matches
end

function M.setup(config)
	M.config = config or {}

	vim.Micro = vim.Micro or {}

	setup_module("breadcrumbs", require("micro.breadcrumbs"), M.config.breadcrumbs)

	vim.api.nvim_create_user_command("Micro", function(cmd)
		if #cmd.fargs < 2 then
			vim.notify("Usage: :Micro <module> <command>", vim.log.levels.WARN, { title = "Micro" })
			return
		end

		local handler = subcommands[cmd.fargs[1]] and subcommands[cmd.fargs[1]][cmd.fargs[2]]
		if not handler then
			vim.notify(
				string.format("Unknown subcommand: %s %s", cmd.fargs[1], cmd.fargs[2]),
				vim.log.levels.ERROR,
				{ title = "Micro" }
			)
			return
		end

		handler()
	end, {
		nargs = "+",
		complete = complete,
		desc = "Dispatch to Micro subcommands.",
	})
end

return M

