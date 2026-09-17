local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- center after move
map("n", "<C-d>", function()
	vim.cmd([[execute "normal! \<C-d>"]])
	vim.cmd("normal! zz")
end)
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

vim.keymap.set("n", "<Esc>", function()
	-- clear "f" and "t" search of flash if active
	local ok, char = pcall(require, "flash.plugins.char")
	if ok and char.state then
		char.state:hide()
	end
	-- clear global highlights
	vim.cmd("noh")
end, { desc = "general clear highlights" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- Diagnostics
map("n", "<A-b>", function()
	-- no float to show tiny-inline-diagnostic
	vim.diagnostic.jump({ count = 1, float = false })
end)
map("n", "<A-S-b>", function()
	vim.diagnostic.jump({ count = -1, float = false })
end)
