return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	init = function()
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		vim.o.foldmethod = "expr"
		vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
	config = function()
		require("ufo").setup({})

		-- Persist folds only for normal files (skip diff mode: mkview would
		-- capture the temporary foldmethod=diff and loadview would replay it forever)
		vim.api.nvim_create_autocmd("BufWinLeave", {
			callback = function()
				if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" and not vim.wo.diff then
					pcall(vim.cmd, "mkview")
				end
			end,
		})

		vim.api.nvim_create_autocmd("BufWinEnter", {
			callback = function()
				if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
					pcall(vim.cmd, "loadview")
				end
			end,
		})

		-- Enable UFO folds automatically
		vim.api.nvim_create_autocmd("BufReadPost", {
			callback = function()
				vim.cmd("UfoEnableFold")
			end,
		})
	end,
}
