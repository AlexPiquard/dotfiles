return {
	{
		-- list of tabs at top
		"nanozuki/tabby.nvim",
		event = { "BufReadPost", "BufNewFile" },
		---@type TabbyConfig
		opts = {
			preset = "tab_only",
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
}
