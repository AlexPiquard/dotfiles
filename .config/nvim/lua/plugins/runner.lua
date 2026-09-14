return {
	-- A neovim plugin to run lines/blocs of code (independently of the rest of the file)
	"michaelb/sniprun",
	branch = "master",

	build = "sh install.sh",
	opts = {},
	keys = {
		{ "<leader>rr", "<Plug>SnipRun", desc = "SnipRun", mode = { "n", "v" }, silent = true },
	},
}
