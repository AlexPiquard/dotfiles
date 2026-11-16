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
				condition = function(self, ctx)
					local cargo_toml = vim.fs.find("Cargo.toml", { path = ctx.filename, upward = true })[1]
					if not cargo_toml then
						return false
					end
					for line in io.lines(cargo_toml) do
						if line:match("^topcoat%s*=") or line:match('^"topcoat"%s*=') then
							return true
						end
					end
					return false
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
