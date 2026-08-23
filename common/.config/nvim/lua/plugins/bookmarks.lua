return {
	-- Bookmark your files, separated by project, and quickly navigate through them.
	"otavioschwanck/arrow.nvim",
	dependencies = {
		{ "echasnovski/mini.icons" },
	},
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		show_icons = true,
		leader_key = "m",
		-- per buffer mappings
		buffer_leader_key = "<nil>",
		index_keys = "hijklmnopuabcfgqrtwxyz",
	},
}
