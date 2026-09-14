return {
	{
		"dhruvasagar/vim-table-mode",
		ft = "markdown",
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
		ft = { "markdown" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			latex = { enabled = false },
			completions = {
				blink = {
					enabled = true,
				},
				lsp = { enabled = true },
			},
			file_types = {
				"markdown",
			},
			html = {
				comment = {
					conceal = false,
				},
			},
		},
	},
}
