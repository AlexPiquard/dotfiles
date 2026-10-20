return {
	-- TODO: search results (needs nvim-hlslens) ?
	"petertriho/nvim-scrollbar",
	event = { "BufReadPost", "BufNewFile" },
	branch = "refactor/v2",
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	opts = {
		exclude = { filetypes = { aerial = true, prompt = true, ["blink-cmp-menu"] = true } },
		providers = { gitsigns = true },
	},
}
