return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			-- condition = function()
			-- 	return false
			-- end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.

			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			ignore_filetypes = { cpp = true }, -- or { "cpp", }
			color = {
				--				suggestion_color = "#ffffff",
				cterm = 244,
			},
			log_level = "info", -- set to "off" to disable logging completely
			disable_inline_completion = false, -- disables inline completion for use with cmp
			disable_keymaps = false, -- disables built in keymaps for more manual control
		})
	end,

	vim.keymap.set("n", "<leader>sm", function()
		require("supermaven-nvim.api").toggle()
		local running = require("supermaven-nvim.api").is_running()
		vim.notify("Supermaven is now " .. (running and "on" or "off"))
	end, { desc = "Toggle Supermaven" }),
}
