return {
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		opts = {
			filewatching = "roslyn",
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		version = "^2.0.0",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"lua_ls",
					"eslint",
					"gopls",
					"golangci_lint_ls",
					"tailwindcss",
					"html",
					"prismals",
				},
				automatic_enable = false,
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		version = "^2.0.0",
		config = function()
			require("mason").setup({
				registries = { "github:Crashdummyy/mason-registry", "github:mason-org/mason-registry" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local root_pattern = vim.fs.root

			----------

			-- vim.lsp.config("eslint", {
			-- 	capabilities = capabilities,
			-- 	on_attach = function(_, bufnr)
			-- 		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 			buffer = bufnr,
			-- 			command = "EslintFixAll",
			-- 		})
			-- 	end,
			-- })
			vim.lsp.config("eslint", {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					if client.name ~= "eslint" then
						return
					end

					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.fixAll.eslint" },
									diagnostics = {},
								},
							})
						end,
					})
				end,
			})
			-- Set up LSPs with capabilities
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					local root = root_pattern(bufnr, { "package.json", "tsconfig.json", ".git" })
					if root then
						on_dir(root)
					end
				end,
				single_file_support = true,
				handlers = {
					["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
						if not result.diagnostics then
							return
						end

						local idx = 1
						while idx <= #result.diagnostics do
							local entry = result.diagnostics[idx]
							local formatter = require("format-ts-errors")[entry.code]
							entry.message = formatter and formatter(entry.message) or entry.message

							if entry.code == 80001 then
								table.remove(result.diagnostics, idx)
							else
								idx = idx + 1
							end
						end

						vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx)
					end,
				},
			})

			vim.lsp.config("denols", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					local root = root_pattern(bufnr, { "deno.json", "deno.jsonc" })
					if root then
						on_dir(root)
					end
				end,
				single_file_support = false,
			})

			-- List of LSPs to set up
			vim.lsp.enable({
				-- "lua_ls",
				"gopls",
				"golangci_lint_ls",
				"tailwindcss",
				"ts_ls",
				"eslint",
				-- "pyright",
				"html",
				-- "tailwindcss",
				-- "rust_analyzer",
				"prismals",
				-- "roslyn",
			})

			vim.g.markdown_fenced_languages = {
				"ts=typescript",
			}

			vim.bo.smartindent = true

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
