return {
	{
		-- show key mappings
		"folke/which-key.nvim",
		event = "VeryLazy",
		cmd = "WhichKey",
		opts = {
			preset = "helix",
			spec = {
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "Finders" },
			},
			win = {
				border = "single",
			},
			plugins = {
				marks = false,
			},
		},
		keys = {
			{ "<leader>wK", "<cmd>WhichKey <CR>", desc = "whichkey all keymaps" },
			{
				"<leader>wk",
				function()
					vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
				end,
				desc = "whichkey query lookup",
			},
		},
	},
}
