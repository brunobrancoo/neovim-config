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
				-- Anchor on the WORKSPACE root, not the nearest package.
				-- In a monorepo every package has its own package.json/tsconfig.json, so the
				-- nearest-match lookup spawns one tsserver per package (5 files = 5 tsservers,
				-- each loading its own program). Workspace markers first keeps it to one.
				root_dir = function(bufnr, on_dir)
					local root = root_pattern(bufnr, {
						"bun.lock",
						"pnpm-workspace.yaml",
						"turbo.json",
						"nx.json",
						"lerna.json",
						".git",
					}) or root_pattern(bufnr, { "package.json", "tsconfig.json" })
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
				"biome",
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

			-- vim.g.markdown_fenced_languages = {
			-- 	"ts=typescript",
			-- }

			-- tailwindcss ships a very wide filetype list and fires textDocument/documentColor
			-- on every keystroke. On a plain .ts backend file that is pure overhead, so only
			-- attach it where class strings actually live.
			vim.lsp.config("tailwindcss", {
				filetypes = {
					"html",
					"css",
					"scss",
					"less",
					"postcss",
					"sass",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
					"astro",
					"htmlangular",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("brunobranco_lsp_perf", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end

					-- semanticTokens/full costs ~1.6s on a 4k-line file in a 10k-file program,
					-- and tsserver is single threaded, so completion queues behind it.
					-- Treesitter already highlights TS/JS.
					if client.name == "ts_ls" then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})

			vim.bo.smartindent = true

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
