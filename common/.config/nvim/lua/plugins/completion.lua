local function get_mini_icon(ctx)
	if ctx.source_name == "Path" then
		local is_unknown_type =
			vim.tbl_contains({ "link", "socket", "fifo", "char", "block", "unknown" }, ctx.item.data.type)
		local mini_icon, mini_hl, _ = require("mini.icons").get(
			is_unknown_type and "os" or ctx.item.data.type,
			is_unknown_type and "" or ctx.label
		)
		if mini_icon then
			return mini_icon, mini_hl
		end
	end
	local mini_icon, mini_hl, _ = require("mini.icons").get("lsp", ctx.kind)
	return mini_icon, mini_hl
end

return {
	-- autocomplete & suggestions
	"saghen/blink.cmp",
	event = { "BufReadPost", "BufNewFile" },

	dependencies = {
		"saghen/blink.lib",
		{
			-- snippet plugin
			"L3MON4D3/LuaSnip",
			dependencies = {
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})
				end,
			},
			build = "make install_jsregexp",
			opts = {
				history = true,
				delete_check_events = "TextChanged",
			},
			keys = {
				{
					"<A-m>",
					function()
						if require("luasnip").jumpable(1) then
							vim.schedule(function()
								require("luasnip").jump(1)
							end)
							return true
						end
					end,
					mode = { "i", "s" },
					desc = "Snippet: Jump forward",
				},
			},
		},

		-- adds words from entire project as completions
		"mikavilpas/blink-ripgrep.nvim",

		-- better colors for entries
		"xzbdmw/colorful-menu.nvim",
	},

	build = function()
		-- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
		-- you can use `gb` in `:Lazy` to rebuild the plugin as needed
		require("blink.cmp").build():pwait()
	end,

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		snippets = { preset = "luasnip" },
		cmdline = { enabled = true },
		appearance = { nerd_font_variant = "normal" },
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
		sources = {
			default = { "lsp", "snippets", "buffer", "path", "ripgrep" },
			per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
			},
			providers = {
				lsp = {
					async = true,
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					---@module "blink-ripgrep"
					---@type blink-ripgrep.Options
					opts = {},
					-- shown last
					score_offset = -500,
				},
				buffer = {
					score_offset = -1000
				}
			},
		},

		-- show function parameters (disabled to use noice)
		signature = { enabled = false },

		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
		},

		completion = {
			keyword = { range = "prefix" },
			ghost_text = { enabled = false },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
				window = { border = "single" },
				treesitter_highlighting = true,
			},

			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},

			accept = {
				auto_brackets = {
					kind_resolution = {
						-- fix auto brackets for react
						blocked_filetypes = {},
					},
				},
			},

			menu = {
				enabled = true,
				scrollbar = false,
				border = "single",
				max_height = 30,
				draw = {
					treesitter = { "lsp" },
					columns = { { "kind_icon" }, { "label", "kind", gap = 1 } },
					components = {
						kind_icon = {
							text = function(ctx)
								local kind_icon, _ = get_mini_icon(ctx)
								return kind_icon
							end,
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl = get_mini_icon(ctx)
								-- check for color derived from documentation
								if ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr_hl_group then
										hl = color_item.abbr_hl_group
									end
								end
								return hl
							end,
						},
						kind = {
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl = get_mini_icon(ctx)
								return hl
							end,
						},
						label = {
							text = function(ctx)
								local highlights_info = require("colorful-menu").blink_highlights(ctx)
								if highlights_info ~= nil then
									-- Or you want to add more item to label
									return highlights_info.label
								else
									return ctx.label
								end
							end,
							highlight = function(ctx)
								local highlights = {}
								local highlights_info = require("colorful-menu").blink_highlights(ctx)
								if highlights_info ~= nil then
									highlights = highlights_info.highlights
								end
								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end
								-- Do something else
								return highlights
							end,
						},
					},
				},
			},
		},
	},
}
