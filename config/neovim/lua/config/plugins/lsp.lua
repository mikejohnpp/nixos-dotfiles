return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
			-- manually install packages that do not exist in this list please
			ensure_installed = {
				"ts_ls",
				"jdtls",
				"bashls",
				"tailwindcss",
				"yamlls",
				"laravel_ls",
				"phpactor",
				"vue_ls",
				"rust_analyzer",
			},
			automatic_installation = false,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local vue_language_server = vim.fn.expand("$MASON")
				.. "/packages/vue-language-server/node_modules/@vue/language-server"
			-- lua
			vim.lsp.config["lua_ls"] = {
				cmd = { "lua-language-server" },
				capabilities = capabilities,
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
			}
			vim.lsp.enable("lua_ls")

			vim.lsp.config["ts_ls"] = {
				capabilities = capabilities,
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vue_language_server,
							languages = { "vue" },
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			}

			vim.lsp.config["yamlls"] = {
				capabilities = capabilities,
			}

			vim.lsp.config["tailwindcss"] = {
				capabilities = capabilities,
			}

			-- vim.lsp.config["html"] = {
			-- 	capabilities = capabilities,
			-- }

			-- nix
			vim.lsp.config["nil_ls"] = {
				capabilities = capabilities,
			}

			-- python
			vim.lsp.config["pyright"] = {
				capabilities = capabilities,
			}

			-- bash
			vim.lsp.config["bashls"] = {
				capabilities = capabilities,
			}

			-- phpactor
			vim.lsp.config["phpactor"] = {
				capabilities = capabilities,
				cmd = { "phpactor", "language-server" },
				filetypes = { "php" },
				root_markers = { ".git", "composer.json", ".phpactor.json", ".phpactor.yml" },
				workspace_required = true,
				init_options = {
					["language_server_phpstan.enabled"] = false,
					["language_server_psalm.enabled"] = false,
					["completion_worse.completor.docblock.enabled"] = false,
				},
			}

			-- laravel-ls
			-- vim.lsp.config["laravel_ls"] = {
			-- 	capabilities = capabilities,
			-- }

			-- vim.lsp.config["clangd"] = {
			-- 	capabilities = capabilities,
			-- 	opts = {
			-- 		servers = {
			-- 			clangd = {
			-- 				mason = false,
			-- 			},
			-- 		},
			-- 	},
			-- }

			vim.lsp.config["ccls"] = {
				capabilities = capabilities,
				cmd = { "ccls" },
			}

			vim.diagnostic.config({
				virtual_text = true,
				underline = true,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "proto",
				callback = function()
					vim.lsp.enable("buf_language_server")
				end,
			})
			vim.lsp.enable({
				"ts_ls",
				"zls",
				"yamlls",
				"phpactor",
				-- "html",
				"tailwindcss",
				"nil_ls",
				"pyright",
				"bashls",
				"laravel_ls",
				"ccls",
			})
			-- LSP floating windows config (Neovim 0.11+)
			local float_opts = {
				border = "rounded",
				winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder",
			}

			-- Diagnostic float
			vim.diagnostic.config({
				virtual_text = true,
				underline = true,
				float = {
					border = "rounded",
					winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder",
				},
			})
			-- lsp kepmap setting
			vim.keymap.set("n", "gh", function()
				vim.lsp.buf.hover(float_opts)
			end, { desc = "LSP hover" })
			-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
			vim.keymap.set("n", "gr", function()
				require("telescope.builtin").lsp_references()
			end, { desc = "LSP references" })
			vim.keymap.set("n", "gd", function()
				require("telescope.builtin").lsp_definitions()
			end, { desc = "LSP definition" })
			vim.keymap.set("n", "gD", function()
				require("telescope.builtin").lsp_type_definitions()
			end, { desc = "LSP type definitions" })
			vim.keymap.set("n", "gi", function()
				require("telescope.builtin").lsp_implementations()
			end, { desc = "LSP implementations" })
			-- working with go confirmed, don't know about other, keep changing as necessary
			vim.keymap.set("n", "<leader>fm", function()
				local filetype = vim.bo.filetype
				local symbols_map = {
					python = "function",
					javascript = "function",
					typescript = "function",
					java = "class",
					lua = "function",
					go = { "method", "struct", "interface" },
				}
				local symbols = symbols_map[filetype] or "function"
				require("telescope.builtin").lsp_document_symbols({ symbols = symbols })
			end, { desc = "Document symbol" })
		end,
	},
}
