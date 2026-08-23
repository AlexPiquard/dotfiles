return {
	-- TODO: search results (needs nvim-hlslens) ?
	"petertriho/nvim-scrollbar",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		excluded_filetypes = {
			"blink-cmp-menu",
			"noice",
			"prompt",
			"aerial",
		},
	},
}
