return {
	-- bottom bar
	"nvim-lualine/lualine.nvim",
	lazy = false,
	opts = {
		extensions = { "lazy", "mason" },
		options = {
			globalstatus = true,
		},
		sections = {
			lualine_b = {
				"branch",
				"diff",
				{
					"diagnostics",
					symbols = {
						error = "󰅙 ",
						warn = " ",
						info = "󰋼 ",
						hint = "󰌵 ",
					},
				},
			},
		},
	},
}
