return {
	-- formatting
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>pp",
			function()
				require("conform").format()
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		async = true,
		lsp_fallback = true,

		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "biome-check" },
			typescript = { "biome-check" },
			typescriptreact = { "biome-check" },
			json = { "biome-check" },
			jsonc = { "biome-check" },
			html = { "prettier" },
			java = { "google-java-format" },
			rust = { "rustfmt" },
		},
	},
}
