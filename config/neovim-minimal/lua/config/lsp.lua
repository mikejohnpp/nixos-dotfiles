local M = {}

local function on_attach(args)
	local client = vim.lsp.get_client_by_id(args.data.client_id)
	if client and client:supports_method("textDocument/completion") then
		vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
	end

	local float_opts = {
		border = "rounded",
		winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder",
	}

	local bmap = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
	end

	-- Navigation
	bmap("n", "gh", function()
		vim.lsp.buf.hover(float_opts)
	end, "LSP: Hover")
	bmap("n", "gr", vim.lsp.buf.references, "LSP: References")
	bmap("n", "gd", vim.lsp.buf.definition, "LSP: Definition")
	bmap("n", "gD", vim.lsp.buf.type_definition, "LSP: Type Definitions")
	bmap("n", "gi", vim.lsp.buf.implementation, "LSP: Implementations")

	-- Refactor
	bmap("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
	bmap({ "n", "v" }, "<leader>ca", function()
		if vim.bo.filetype == "rust" and vim.fn.exists(":RustLsp") == 2 then
			vim.cmd.RustLsp("codeAction")
		else
			vim.lsp.buf.code_action()
		end
	end, "LSP: Code Action")

	-- Diagnostics
	bmap("n", "<leader>df", vim.diagnostic.open_float, "LSP: Show line diagnostics")
	bmap("n", "<leader>lx", function()
		local cfg = vim.diagnostic.config()
		vim.diagnostic.config({ virtual_text = not cfg.virtual_text })
	end, "LSP: Toggle virtual text")

	-- Codelens
	bmap("n", "<leader>lc", vim.lsp.codelens.run, "LSP: Run CodeLens action")
	bmap("n", "<leader>lt", function()
		vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
	end, "LSP: Toggle CodeLens")
end

function M.setup()


	-- Diagnostics UI (use plain UTF-8, no nerd font icons)
--	local signs_fill = {
--		[vim.diagnostic.severity.ERROR] = "[E]",
--		[vim.diagnostic.severity.WARN] = "[W]",
--		[vim.diagnostic.severity.HINT] = "[H]",
--		[vim.diagnostic.severity.INFO] = "[I]",
--	}

	vim.diagnostic.config({
--		signs = { text = signs_fill },
		virtual_text = {
			prefix = "> ",
			spacing = 4,
			source = "if_many",
			severity = { min = vim.diagnostic.severity.WARN },
			format = function(diag)
				return diag.message:gsub("%s+", " "):sub(1, 80)
			end,
		},
		underline = true,
		update_in_insert = false,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = true,
			winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder",
		},
	})

	vim.lsp.codelens.enable(false)

	-- LSP configs (native API, no require('lspconfig'))
	vim.lsp.config("*", {
		capabilities = vim.lsp.protocol.make_client_capabilities(),
	})

	-- lua_ls
	vim.lsp.config("lua_ls", {
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	})

  vim.lsp.config("ccls", {
		cmd = { "ccls" },
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		offset_encoding = "utf-32",
		root_dir = function(bufnr, on_dir)
			local root = vim.fs.root(bufnr, { "compile_commands.json", ".ccls", ".git" })
				or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
				or vim.fn.getcwd()
			on_dir(root)
		end,
  })

	-- bashls
	vim.lsp.config("bashls", {})

	-- nil_ls (Nix)
	vim.lsp.config("nil_ls", {})

	-- Enable servers (minimal set)
	pcall(vim.lsp.enable, { "lua_ls", "bashls", "nil_ls", "ccls" })

	-- LspAttach
	local augroup = function(name)
		return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
	end
	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup("lsp_attach"),
		callback = on_attach,
	})
end

return M
