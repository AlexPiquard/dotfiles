return {
	-- formatting
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
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

		format_on_save = { timeout_ms = 500 },

		formatters = {
			topcoat = {
				command = "topcoat",
				args = { "fmt", "--stdin" },
				require_cwd = true,
				cwd = function(self, ctx)
					return require("conform.util").root_file({ "Topcoat.toml" })(self, ctx)
				end,
			},
		},

		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "biome", "biome-organize-imports" },
			typescript = { "biome", "biome-organize-imports" },
			typescriptreact = { "biome", "biome-organize-imports" },
			json = { "biome", "biome-organize-imports" },
			jsonc = { "biome", "biome-organize-imports" },
			html = { "prettier" },
			java = { "google-java-format" },
			rust = { "topcoat", "rustfmt" },
		},
	},
}
