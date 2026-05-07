return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local parsers = {
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"prisma",
			"markdown",
			"markdown_inline",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"vimdoc",
			"c",
		}

		require("nvim-treesitter").setup()

		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"json",
				"html",
				"css",
				"lua",
			},
			callback = function(args)
				local filetype = vim.bo[args.buf].filetype
				local lang = vim.treesitter.language.get_lang(filetype)

				if not lang then
					return
				end

				local ok = pcall(vim.treesitter.start, args.buf, lang)

				if not ok then
					return
				end

				vim.bo[args.buf].indentexpr = ""
				vim.bo[args.buf].indentkeys = ""
				vim.bo[args.buf].autoindent = true
				vim.bo[args.buf].smartindent = true
				vim.bo[args.buf].cindent = false
			end,
		})
	end,
}
