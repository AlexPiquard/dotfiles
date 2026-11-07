local open_lazygit = function()
	local width = math.floor(vim.o.columns * 0.85)
	local height = math.floor(vim.o.lines * 0.85)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "none",
	})

	vim.fn.jobstart("lazygit", {
		term = true,
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})

	vim.cmd("startinsert")
end

return {
	-- git stuff
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		signs = {
			delete = { text = "󰍵" },
			changedelete = { text = "󱕖" },
		},
	},
	keys = {
		{ "<leader>hr", "<CMD>Gitsigns reset_hunk<CR>", desc = "Git reset hunk", mode = { "n", "v" } },
		{
			mode = "v",
			"<leader>hr",
			function()
				require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			desc = "Git reset hunk",
		},
		{ "<leader>hR", "<CMD>Gitsigns reset_buffer<CR>", desc = "Git reset buffer" },
		{ "<leader>hp", "<CMD>Gitsigns preview_hunk<CR>", desc = "Git preview hunk" },
		{
			"<leader>hb",
			"<CMD>Gitsigns blame_line",
			desc = "Git blame",
		},
		{
			"<leader>lg",
			function()
				require("utils").open_cmd_win("lazygit")
			end,
			desc = "LazyGit",
		},
		{
			"<leader>gf",
			"<cmd>Pick git_commits path='%'<cr>",
			desc = "Git log [f]ile",
		},
		{
			"<leader>gl",
			"<cmd>Pick git_commits<cr>",
			desc = "Git [l]og",
		},
		{
			"<leader>gL",
			"<cmd>Pick git_log_line<cr>",
			desc = "Git log [L]ine",
		},
	},
}
