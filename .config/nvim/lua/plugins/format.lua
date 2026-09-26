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
			javascript = { "biome-check" },
			typescript = { "biome-check" },
			typescriptreact = { "biome-check" },
			json = { "biome-check" },
			jsonc = { "biome-check" },
			html = { "prettier" },
			java = { "google-java-format" },
			rust = { "topcoat", "rustfmt" },
		},
	},
}
