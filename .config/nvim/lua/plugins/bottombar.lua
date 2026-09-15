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
					-- show diagnostics of the whole project with workspace-diagnostics
					sources = { "nvim_workspace_diagnostic" },
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
