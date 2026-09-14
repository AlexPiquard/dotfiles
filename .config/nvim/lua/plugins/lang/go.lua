return {
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				gopls = true
			},
		},
	},
	{
		"mason-org/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				gopls = {
					executable_cond = "go",
				},
			},
		},
	},
}
