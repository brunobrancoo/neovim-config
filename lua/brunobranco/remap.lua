vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "gh", "_", { noremap = true, silent = true })
vim.keymap.set("n", "gl", "$", { noremap = true, silent = true })

--keeping cursor on the middle while jumpping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--keeping cursor on the middle while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--find word under cursos inside document
vim.keymap.set("n", "<leader>sw", "yiw/<C-r>0<CR>")

--open lazy git
-- vim.keymap.set("n", "<leader>gc", ":Gvdiffsplit!<CR>")
vim.keymap.set("n", "<leader>lg", ":Lazygit<CR>")

--best remap ever
vim.keymap.set("x", "<leader>p", '"_dP')

--let it snow!!
vim.keymap.set("n", "<leader>lis", ":LetItSnow<CR>")
vim.keymap.set("n", "<leader>sts", ":EndHygge<CR>")
vim.keymap.set("n", "<C-b>", ":b#<CR>")

-- Built in undotree
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

--open error window lsp
vim.keymap.set("n", "<leader>lw", ":LspDiagnosticsWarning<CR>")
vim.keymap.set("n", "<leader>li", ":LspDiagnosticsInformation<CR>")
vim.keymap.set("n", "<leader>lc", ":LspDiagnosticsHint<CR>")
vim.keymap.set("n", "<leader>la", ":LspDiagnosticsToggle<CR>")

--terminal commands
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>:q<CR>")
vim.keymap.set("t", "<C-n>", "<C-\\><C-n>")
vim.keymap.set("n", "<C-q>", ":q<CR>")

--copy current buffer dir
vim.keymap.set(
	"n",
	"<leader>yd",
	[[:let @+ = expand('%:h')<CR>]],
	{ noremap = true, silent = true, desc = "Copy file directory" }
)

-- open lsp message in buffer
vim.keymap.set("n", "<space>le", function()
	local bufnr = vim.api.nvim_get_current_buf() -- Get current buffer number
	vim.diagnostic.open_float(nil, { buf = bufnr + 1 }) -- Open diagnostics for that buffer
end, { noremap = true, silent = true })

--oil thing
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

--#for resizing windows
vim.keymap.set("n", "<leader>++", "<cmd>vertical resize +20<CR>", { desc = "Zoom in" }) -- refresh file explorer
vim.keymap.set("n", "<leader>--", "<cmd>vertical resize -20<CR>", { desc = "Zoom out" }) -- refresh file explorer

--#toggle hlsearch
vim.keymap.set("n", "<C-h>", function()
	local hlsearch = vim.opt.hlsearch:get()
	local msg = "hlsearch " .. tostring(not hlsearch)
	vim.cmd("echo '" .. msg .. "'")
	vim.opt.hlsearch = not hlsearch
end, { desc = "Toggle hlsearch" })

--restart null_ls
vim.api.nvim_create_user_command("Reslsp", function()
	vim.cmd("lsp restart null-ls")
end, { desc = "Restart null_ls" })
