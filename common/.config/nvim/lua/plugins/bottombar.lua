return {
	-- bottom bar
	"nvim-lualine/lualine.nvim",
	lazy = false,
	config = function()
		require("lualine").setup({
			extensions = { "lazy" },
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
		})
	end,
}
