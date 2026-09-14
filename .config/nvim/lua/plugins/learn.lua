return {
	{
		-- Break bad habits, master Vim motions
		"m4xshen/hardtime.nvim",
		enabled = false,
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			disabled_filetypes = {
				lazy = true,
				["dapui*"] = true,
				fyler = true,
			},
		},
	},
	{
		-- personalized command discovery based on your actual usage
		"kamegoro/tobira.nvim",
		enabled = false,
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
	{
		-- show key mappings
		"folke/which-key.nvim",
		lazy = false,
		cmd = "WhichKey",
		opts = {
			preset = "helix",
			spec = {
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "Finders" },
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
