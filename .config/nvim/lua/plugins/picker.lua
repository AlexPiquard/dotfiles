return {
	{
		"folke/snacks.nvim",
		priority = 900,
		lazy = false,
		---@type snacks.config
		opts = {
			animate = { enabled = true },
			bigfile = { enabled = true },
			-- open single files quickly
			quickfile = { enabled = true },
			bufdelete = { enabled = true },
			picker = {
				enabled = true,
				exclude = { "bin" },
				sources = {
					files = { hidden = true },
					grep = { hidden = true },
					todo_comments = { hidden = true },
				},
				matcher = { smartcase = false },
				jump = {
					reuse_win = true,
				},
				layout = "custom",
				layouts = {
					custom = {
						layout = {
							backdrop = false,
							box = "horizontal",
							width = 0.8,
							min_width = 120,
							height = 0.8,
							{
								box = "vertical",
								border = true,
								title = "{title} {live} {flags}",
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "none" },
							},
							{ win = "preview", title = "{preview}", border = true, width = 0.5 },
						},
					},
				},
				win = {
					input = {
						keys = {
							-- S-CR cant be made, so we define another keymap
							["<C-w>"] = { { "pick_win", "jump" }, mode = { "i", "n" } },
							["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
						},
					},
				},
				actions = {
					opencode_send = function(picker) ---@param picker snacks.Picker
						local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
							return item.file
									and require("opencode").format({
										path = item.file,
										from = item.pos,
										to = item.end_pos,
									})
								or item.text
						end, picker:selected({ fallback = true }))

						require("opencode").prompt(table.concat(items, ", ") .. " ")
					end,
				},
			},
			statuscolumn = { enabled = true },
			-- just indent visual guides
			indent = { enabled = true },
			image = { enabled = true },
			input = { enabled = true },
		},
		keys = {
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete buffer",
			},
			{ "<leader>bD", "<cmd>:bd<cr>", desc = "Delete buffer and window" },
			{
				"<leader>bo",
				function()
					Snacks.bufdelete.other()
				end,
				desc = "Delete other buffers",
			},
			{
				"<leader>bi",
				function()
					Snacks.bufdelete.invisible()
				end,
				desc = "Delete invisible buffers",
			},
			{
				"<leader>,",
				function()
					Snacks.picker.buffers({
						unloaded = false,
						win = {
							input = {
								keys = {
									["dd"] = { "bufdelete", mode = { "n" } },
								},
							},
						},
					})
				end,
				desc = "Buffers",
			},
		},
	},
	{
		"dmtrKovalenko/fff",
		build = function()
			-- downloads a prebuilt binary or falls back to cargo build
			require("fff.download").download_or_build_binary()
		end,
		opts = {
			prompt = "> ",
			git = {
				status_text_color = true,
			},
			hl = {
				title = "FloatTitle",
				git_staged = "GitSignsAdd",
				git_modified = "GitSignsChange",
				git_deleted = "GitSignsDelete",
				git_renamed = "GitSignsChange",
				git_untracked = "GitSignsUntracked",
				git_ignored = "Comment",
				git_sign_staged = "GitSignsAdd",
				git_sign_staged_selected = "GitSignsAdd",
				git_sign_modified = "GitSignsChange",
				git_sign_modified_selected = "GitSignsChange",
				git_sign_deleted = "GitSignsDelete",
				git_sign_deleted_selected = "GitSignsDelete",
				git_sign_renamed = "GitSignsChange",
				git_sign_renamed_selected = "GitSignsChange",
				git_sign_untracked = "GitSignsUntracked",
				git_sign_untracked_selected = "GitSignsUntracked",
				git_sign_ignored = "Comment",
				git_sign_ignored_selected = "Comment",
				winhl = {
					list = "Normal:NormalFloat,FloatBorder:FloatBorder,FloatTitle:FloatTitle,SignColumn:NormalFloat",
				},
			},
		},
		lazy = false, -- the plugin lazy-initialises itself
		keys = {
			{
				"<leader>ff",
				function()
					require("fff").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fg",
				function()
					require("fff").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fw",
				function()
					require("fff").live_grep_under_cursor()
				end,
				mode = { "n", "x" },
				desc = "Search current word / selection",
			},
			{
				"<leader>fr",
				function()
					require("fff").resume()
				end,
				desc = "Resume",
			},
		},
	},
}
