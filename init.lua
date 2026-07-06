require("brunobranco.settings")
require("brunobranco.remap")
-- require("brunobranco.nord-config")

require("brunobranco.lazy")

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd",
		pager = { height = 0.5 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
		msg = { height = 0.5, timeout = 4500 },
	},
})

--colorscheme:
-- require("nord").set()
vim.o.background = "dark"

vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

vim.o.winborder = "rounded"

vim.o.foldenable = true
vim.o.foldmethod = "expr"

vim.lsp.enable({ "lua_ls" })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

-- Manage env files
vim.keymap.set("n", "<leader>oe", function()
	local cwd = vim.fn.getcwd()
	local env = cwd .. "/.env"
	local envlocal = cwd .. "/.env.local"

	local target
	if vim.fn.filereadable(env) == 1 then
		vim.cmd("vnew .env")
	elseif vim.fn.filereadable(envlocal) == 1 then
		vim.cmd("vnew .env.local")
	else
		vim.cmd("!touch .env")
		vim.notify("Env file does not exist, press enter to create one")
		vim.cmd("vnew .env")
	end
end, {})

-- vim.api.nvim_create_augroup("ForceNoHlSearch", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "WinEnter" }, {
-- 	group = "ForceNoHlSearch",
-- 	desc = "Always clear search highlight on open/switch",
-- 	callback = function()
-- 		vim.cmd("silent! nohlsearch")
-- 		vim.opt.hlsearch = false
-- 	end,
-- }) -- Optional: also clear on leaving insert so accidental searches don't stick
-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	group = "ForceNoHlSearch",
-- 	callback = function()
-- 		vim.cmd("silent! nohlsearch")
-- 		vim.opt.hlsearch = false
-- 	end,
-- })

vim.opt.autochdir = false

-- Warns when dir changes
vim.api.nvim_create_autocmd("DirChanged", {
	callback = function(args)
		vim.notify("cwd changed to: " .. args.file, vim.log.levels.INFO)
	end,
})

-- This maintains my cwd as always the file I opened neovim, and let's me :cd if I want. Explicit behaviour.
-- vim.api.nvim_create_autocmd("WinEnter", {
-- 	callback = function()
-- 		vim.cmd("lcd -") -- Clear window-local cwd
-- 	end,
-- })

--This maintains my cwd as always the root project, based on .git or .package.json files. Opinionated behaviour.
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		-- Find project root
-- 		local root = vim.fs.find({ ".git", "package.json" }, { upward = true })[1]
--
-- 		if root then
-- 			local root_dir = vim.fs.dirname(root)
-- 			vim.cmd("cd " .. root_dir)
-- 			vim.cmd("windo lcd -") -- Clear all window-local cwd
-- 		end
-- 	end,
-- })
