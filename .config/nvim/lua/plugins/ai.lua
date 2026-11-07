local function scroll(up)
	local pi_pane = require("pi-tmux").get_pi_pane(true)

	if pi_pane then
		if up then
			require("pi-tmux").scroll_up(3)
		else
			require("pi-tmux").scroll_down(3)
		end
	else
		if up then
			require("opencode").command("session.half.page.up")
		else
			require("opencode").command("session.half.page.down")
		end
	end
end

return {
	{
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
	},
	{
		"AlexPiquard/pi-tmux.nvim",
		cmd = "PiTmuxAsk",
		---@type PiTmux.Opts
		opts = {},
		keys = {
			{
				"<leader>a",
				function()
					require("pi-tmux").ask()
				end,
				mode = { "n", "x" },
				desc = "Ask Pi",
			},
			{
				"<M-u>",
				function()
					scroll(true)
				end,
				mode = "n",
				desc = "Scroll Pi or OpenCode up",
			},
			{
				"<M-d>",
				function()
					scroll(false)
				end,
				mode = "n",
				desc = "Scroll Pi or OpenCode down",
			},
		},
	},
}
