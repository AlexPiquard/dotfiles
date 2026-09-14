return {
	"nickjvandyke/opencode.nvim",
	version = "*", -- Latest stable release
	keys = {
		{
			"<C-a>",
			function()
				require("opencode").ask("@this: ")
			end,
			mode = { "n", "x" },
			desc = "Ask OpenCode…",
		},
		{
			"<C-x>",
			function()
				require("opencode").select()
			end,
			mode = { "n", "x" },
			desc = "Select OpenCode…",
		},
		{
			"go",
			function()
				return require("opencode").operator("@this ")
			end,
			mode = { "n", "x" },
			expr = true,
			desc = "Append range to OpenCode",
		},
		{
			"goo",
			function()
				return require("opencode").operator("@this ") .. "_"
			end,
			mode = "n",
			expr = true,
			desc = "Append line to OpenCode",
		},
		{
			"<M-u>",
			function()
				require("opencode").command("session.half.page.up")
			end,
			mode = "n",
			desc = "Scroll OpenCode up",
		},
		{
			"<M-d>",
			function()
				require("opencode").command("session.half.page.down")
			end,
			mode = "n",
			desc = "Scroll OpenCode down",
		},
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your configuration, if any; goto definition on the type for details
			select = {
				prompts = {
					ask = "...",
					diagnostics = "Explique @diagnostics",
					document = "Ajoute des commentaires documentant @this",
					explain = "Explique @this et son contexte",
					fix = "Corrige @diagnostics",
					implement = "Implemente @this",
					optimize = "Optimise @this pour performance lisibilité",
					review = "Vérifie @this pour en assurer l'exactitude et la lisibilité",
					test = "Ajoute des tests pour @this",
				},
			},
		}
	end,
}
