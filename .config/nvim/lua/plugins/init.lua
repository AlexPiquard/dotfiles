local Utils = require("utils")

return {
	{
		{ import = "plugins.lang" },
	},
	{
		-- fix completions in neovim config
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "mini.files", words = { "MiniFiles" } },
				{ path = "mini.pick", words = { "MiniPick" } },
			},
		},
		-- enabled only in dotfiles
		enabled = Utils.is_dotfiles,
	},
}
