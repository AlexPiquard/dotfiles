return {
	{
		-- list of tabs at top
		"nanozuki/tabby.nvim",
		event = { "BufReadPost", "BufNewFile" },
		---@type TabbyConfig
		opts = {
			preset = "active_wins_at_tail",
		},
		keys = {
			{
				"<A-n>",
				"<cmd>tabnew<cr>",
				desc = "New tab",
			},
			{
				"<A-p>",
				"<cmd>tabclose<cr>",
				desc = "Close tab",
			},
			{
				"<A-;>",
				"<cmd>tabnext<cr>",
				desc = "Next tab",
			},
			{
				"<A-,>",
				"<cmd>tabprev<cr>",
				desc = "Previous tab",
			},
		},
	},
	{
		-- buffer list at top
		"romgrk/barbar.nvim",
		lazy = false,
		enabled = false,
		dependencies = {
			"lewis6991/gitsigns.nvim",
			-- mocked by mini.icons
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			animation = true,
			icons = {
				diagnostics = {
					[vim.diagnostic.severity.ERROR] = { enabled = true },
					[vim.diagnostic.severity.WARN] = { enabled = true },
					[vim.diagnostic.severity.INFO] = { enabled = true },
					[vim.diagnostic.severity.HINT] = { enabled = true },
				},
				gitsigns = {
					added = { enabled = true, icon = "+" },
					changed = { enabled = true, icon = "~" },
					deleted = { enabled = true, icon = "-" },
				},
			},
		},
		keys = {
			{
				"<A-,>",
				"<Cmd>BufferPrevious<CR>",
				desc = "Previous buffer",
				mode = "n",
			},
			{
				"<A-;>",
				"<Cmd>BufferNext<CR>",
				desc = "Next buffer",
				mode = "n",
			},
			{
				"<A-k>",
				"<Cmd>BufferClose<CR>",
				desc = "Close buffer",
				mode = "n",
			},
			{
				"<A-p>",
				"<Cmd>BufferPick<CR>",
				desc = "Pick buffer",
				mode = "n",
			},
		},
	},
}
