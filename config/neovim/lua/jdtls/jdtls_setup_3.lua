local home = vim.env.HOME
local mason = vim.env.MASON or (home .. "/.local/share/nvim/mason")
local jdtls_path = mason .. "/packages/jdtls"
local lombok_jar = mason .. "/packages/lombok.jar"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Project root
local root_markers = { "gradlew", "mvnw", ".git" }
local root = vim.fs.find(root_markers, { upward = true })[1]
if not root then
	return
end
local root_dir = vim.fs.dirname(root)

-- Eclipse workspace
local workspace = home .. "/.local/share/eclipse/" .. vim.fs.basename(root_dir)

----------------------------------------------------------------
-- Bundles: debug, test, spring, dependency
----------------------------------------------------------------
local bundles = {}

-- java-test
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar"), "\n"))

-- java-debug (plugin-*.jar)
vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
		"\n"
	)
)

-- Spring Boot
pcall(function()
	vim.list_extend(bundles, require("spring_boot").java_extensions())
end)

-- VSCode Java Dependency extension (optional)
-- local deps_path = home .. "/projects/vscode-java-dependency/jdtls.ext/com.microsoft.jdtls.ext.core/target/"
-- vim.list_extend(bundles, vim.split(
--     vim.fn.glob(deps_path .. "com.microsoft.jdtls.ext.core-*.jar"),
--     "\n"
-- ))

----------------------------------------------------------------
-- DAP Adapter for Java
----------------------------------------------------------------
local dap = require("dap")

dap.adapters.java = function(callback)
	-- FIXME:
	-- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
	-- The response to the command must be the `port` used below
	callback({
		type = "server",
		host = "127.0.0.1",
		port = 5005,
	})
end

dap.configurations.java = {
	{
		type = "java",
		request = "attach",
		name = "Debug (Attach) - Remote",
		hostName = "127.0.0.1",
		port = 5005,
	},
}

----------------------------------------------------------------
-- LSP Config
----------------------------------------------------------------
local capabilities = require("blink.cmp").get_lsp_capabilities()

local extended = require("jdtls").extendedClientCapabilities
extended.resolveAdditionalTextEditsSupport = true

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1G",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok_jar,
		"-jar",
		launcher_jar,
		"-configuration",
		jdtls_path .. "/config_linux",
		"-data",
		workspace,
	},

	root_dir = root_dir,
	capabilities = capabilities,

	settings = {
		java = {
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			configuration = { updateBuildConfiguration = "interactive" },
			references = { includeDecompiledSources = true },
			implementationsCodeLens = { enabled = true },
			referenceCodeLens = { enabled = true },
			inlayHints = { parameterNames = { enabled = "all" } },
			signatureHelp = {
				enabled = true,
				description = { enabled = true },
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
		},
	},

	init_options = {
		bundles = bundles,
		extendedClientCapabilities = extended,
	},

	flags = { allow_incremental_sync = true },

	on_attach = function(client, bufnr)
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()

		-- Toggle dependency tree
		-- vim.api.nvim_buf_create_user_command(bufnr, "JavaProjects", function()
		-- 	require("java-deps").toggle_outline()
		-- end, {})
	end,
}

local function get_spring_boot_runner(profile, debug)
	local debug_param = ""
	if debug then
		-- debug_param =
		-- 	' -Dspring-boot.run.jvmArguments="--add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000" '
		debug_param =
			' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005" '
	end

	local profile_param = ""
	if profile then
		profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
	end

	return "mvn spring-boot:run " .. profile_param .. debug_param
end

local function run_spring_boot(debug)
	vim.cmd("15sp|term " .. get_spring_boot_runner(nil, debug))
end

vim.keymap.set("n", "<F9>", function()
	run_spring_boot()
end)

vim.keymap.set("n", "<F10>", function()
	run_spring_boot(true)
end)

local function attach_to_debug()
	require("dap").configurations.java = {
		{
			type = "java",
			request = "attach",
			name = "Attach to the process",
			hostName = "localhost",
			port = "5005",
		},
	}
	dap.continue()
end

vim.keymap.set("n", "<leader>da", function()
	attach_to_debug()
end)

----------------------------------------------------------------
-- Start JDTLS
----------------------------------------------------------------
require("jdtls").start_or_attach(config)
