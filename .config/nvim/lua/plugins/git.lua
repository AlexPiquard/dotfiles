local open_lazygit = function()
	Snacks.terminal("lazygit", { win = { position = "float", backdrop = 100 } })
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
	config = function(_, opts)
		require("gitsigns").setup(opts)
		-- show git signs in scrollbar
		-- require("scrollbar.handlers.gitsigns").setup()
	end,
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
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git blame",
		},
		{
			"<leader>lg",
			function()
				open_lazygit()
			end,
			desc = "LazyGit",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git log [f]ile",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git [l]og",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git log [L]ine",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git [d]iff",
		},
	},
}
