return {
	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
	},
	{
		"aikhe/wrapped.nvim",
		dependencies = { "nvzone/volt" },
		cmd = { "WrappedNvim" },
		opts = {
			path = os.getenv("HOME") .. "/dotfiles/",
		},
	},
	{
		"stevearc/aerial.nvim",
		opts = {},
		enabled = false,
		cmd = { "AerialToggle" },
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
