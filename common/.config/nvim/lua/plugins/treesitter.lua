local languages = {
	"lua",
	"luadoc",
	"printf",
	"vim",
	"vimdoc",
	"typescript",
	"javascript",
	"tsx",
	"markdown",
	"markdown_inline",
	"html",
	"go",
	"java",
	"rust",
	"yaml",
	"xml",
	"zsh",
	"regex",
}

return {
	-- syntax highlight
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile", "FileType" },
	cmd = { "TSInstall", "TSInstallFromGrammar", "TSUpdate", "TSUninstall", "TSLog" },
	dependencies = {
		{
			-- Bundle of more than 30 new text objects for Neovim.
			"chrisgrieser/nvim-various-textobjs",
			opts = {
				keymaps = {
					useDefaults = true,
					disabledDefaults = { "n" },
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			enabled = false,
			init = function()
				-- Disable entire built-in ftplugin mappings to avoid conflicts.
				vim.g.no_plugin_maps = true
			end,
			config = true,
			keys = {
				-- select
				{
					"am",
					mode = { "x", "o" },
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@function.outer",
							"textobjects"
						)
					end,
					desc = "Select @function.outer",
				},
				{
					"im",
					mode = { "x", "o" },
					function()
						require("nvim-treesitter-textobjects.select").select_textobject(
							"@function.inner",
							"textobjects"
						)
					end,
					desc = "Select @function.inner",
				},
				{
					"ac",
					mode = { "x", "o" },
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
					end,
					desc = "Select @class.outer",
				},
				{
					"ic",
					mode = { "x", "o" },
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
					end,
					desc = "Select @class.inner",
				},
				{
					"as",
					mode = { "x", "o" },
					function()
						require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
					end,
					desc = "Select @local.scope",
				},
				-- swap
				{
					"<leader>a",
					function()
						require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
					end,
					desc = "Swap next @parameter.inner",
				},
				{
					"<leader>A",
					function()
						require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
					end,
					desc = "Swap previous @parameter.outer",
				},
				-- move
				{
					"]m",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
					end,
					desc = "Next @function.outer start",
				},
				{
					"]]",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
					end,
					desc = "Next @class.outer start",
				},
				{
					"]o",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start(
							{ "@loop.inner", "@loop.outer" },
							"textobjects"
						)
					end,
					desc = "Next loop start",
				},
				{
					"]s",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
					end,
					desc = "Next @local.scope start",
				},
				{
					"]z",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
					end,
					desc = "Next fold start",
				},
				{
					"]M",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
					end,
					desc = "Next @function.outer end",
				},
				{
					"][",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
					end,
					desc = "Next @class.outer end",
				},
				{
					"[m",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start(
							"@function.outer",
							"textobjects"
						)
					end,
					desc = "Previous @function.outer start",
				},
				{
					"[[",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
					end,
					desc = "Previous @class.outer start",
				},
				{
					"[M",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
					end,
					desc = "Previous @function.outer end",
				},
				{
					"[]",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
					end,
					desc = "Previous @class.outer end",
				},
				{
					"]d",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
					end,
					desc = "Next @conditional.outer",
				},
				{
					"[d",
					mode = { "n", "x", "o" },
					function()
						require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
					end,
					desc = "Previous @conditional.outer",
				},
			},
		},
	},
	build = ":TSUpdate",
	branch = "main",
	config = function(_, _)
		require("nvim-treesitter").install(languages)

		-- auto-start highlights & indentation
		vim.api.nvim_create_autocmd("FileType", {
			desc = "User: enable treesitter highlighting",
			callback = function(ctx)
				-- highlights
				local hasStarted = pcall(vim.treesitter.start, ctx.buf) -- errors for filetypes with no parser

				-- indent
				if hasStarted then
					vim.bo[ctx.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.opt.foldmethod = "expr"
					vim.opt.foldlevelstart = 99
				end
			end,
		})
	end,
}
