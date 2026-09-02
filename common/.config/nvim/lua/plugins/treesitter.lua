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
	"bash",
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
					-- disable "n" (nearEoL) and "in/an" (numbers, to use native in/an)
					disabledDefaults = { "n", "in", "an" },
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			init = function()
				-- Disable entire built-in ftplugin mappings to avoid conflicts.
				vim.g.no_plugin_maps = true
			end,
			config = function()
				local select = require("nvim-treesitter-textobjects.select").select_textobject
				local move = require("nvim-treesitter-textobjects.move")
				local swap = require("nvim-treesitter-textobjects.swap")

				local select_maps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["a,"] = "@parameter.outer",
					["i,"] = "@parameter.inner",
				}
				for key, capture in pairs(select_maps) do
					vim.keymap.set({ "x", "o" }, key, function()
						select(capture, "textobjects")
					end)
				end

				local move_maps = {
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["],"] = "@parameter.inner",
					},
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]K"] = "@parameter.inner" },
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[,"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[K"] = "@parameter.inner",
					},
				}
				for method, mappings in pairs(move_maps) do
					for key, capture in pairs(mappings) do
						vim.keymap.set({ "n", "x", "o" }, key, function()
							move[method](capture, "textobjects")
						end)
					end
				end

				local swap_maps = { [">,"] = "@parameter.inner", ["<,"] = "@parameter.inner" }
				for key, capture in pairs(swap_maps) do
					local fn = key == ">," and function()
						swap.swap_next(capture, "textobjects")
					end or function()
						swap.swap_previous(capture, "textobjects")
					end
					vim.keymap.set("n", key, fn)
				end

			end,
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
