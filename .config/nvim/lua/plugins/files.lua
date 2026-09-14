-- create a mapping to open the selected buffer in a split view
local map_split = function(buf_id, lhs, direction)
	local rhs = function()
		-- Make new window and set it as target
		local cur_target = MiniFiles.get_explorer_state().target_window
		local new_target = vim.api.nvim_win_call(cur_target, function()
			vim.cmd(direction .. " split")
			return vim.api.nvim_get_current_win()
		end)

		MiniFiles.set_target_window(new_target)
		MiniFiles.go_in()
	end

	local desc = "Split " .. direction
	vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

-- create mappings for split views when files open
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		-- mappings for split view
		local buf_id = args.data.buf_id
		map_split(buf_id, "<C-h>", "belowright horizontal")
		map_split(buf_id, "<C-v>", "belowright vertical")
		map_split(buf_id, "<C-t>", "tab")
	end,
})

return {
	{
		"nvim-mini/mini.files",
		dependencies = {
			"nvim-mini/mini.icons",
		},
		opts = {
			-- Customization of shown content
			content = {
				-- Predicate for which file system entries to show
				filter = nil,
				-- What prefix to show to the left of file system entry
				prefix = nil,
				-- In which order to show file system entries
				sort = nil,
			},

			-- Module mappings created only inside explorer.
			-- Use `''` (empty string) to not create one.
			mappings = {
				close = "q",
				go_in = "l",
				go_in_plus = "L",
				go_out = "h",
				go_out_plus = "H",
				mark_goto = "'",
				mark_set = "m",
				reset = "<BS>",
				reveal_cwd = "n",
				show_help = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},

			-- General options
			options = {
				-- Whether to delete permanently or move into module-specific trash
				permanent_delete = false,
				-- Whether to use for editing directories
				use_as_default_explorer = true,
			},

			-- Customization of explorer windows
			windows = {
				-- Maximum number of windows to show side by side
				max_number = math.huge,
				-- Whether to show preview of file/directory under cursor
				preview = false,
				-- Width of focused window
				width_focus = 50,
				-- Width of non-focused window
				width_nofocus = 15,
				-- Width of preview window
				width_preview = 25,
			},
		},
		keys = {
			{
				"<C-n>",
				function()
					local buf_name = vim.api.nvim_buf_get_name(0)
					local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
					MiniFiles.open(path) -- opens only current folder
					MiniFiles.reveal_cwd() -- shows folders up to root
				end,
				desc = "Open file explorer at current folder",
			},
		},
		-- config = function()
		-- 	-- show git status of files
		-- 	require("scripts.mini-files-git").Init_mini_files_git_integration()
		-- end,
	},
	{
		-- A neovim file manager which can edit file system like a buffer with tree view
		"A7Lavinraj/fyler.nvim",
		enabled = false,
		dependencies = { "nvim-mini/mini.icons" },
		opts = {
			hooks = {},
			integrations = {
				icon = "mini_icons",
				-- opens file in current window
				winpick = "none",
			},
			views = {
				finder = {
					-- forced to true when kind=float|replace
					close_on_select = true,
					-- Skip confirmation for simple operations
					confirm_simple = true,
					default_explorer = false,
					delete_to_trash = false,
					columns_order = { "permission", "size", "git", "diagnostic" },
					columns = {
						git = {
							enabled = true,
							symbols = {
								Untracked = "?",
								Added = "+",
								Modified = "~",
								Deleted = "-",
								Renamed = "→",
								Copied = "c",
								Conflict = "!",
								Ignored = " ",
							},
						},
						diagnostic = {
							enabled = true,
							symbols = {
								Error = "󰅙 ",
								Warn = " ",
								Info = "󰋼 ",
								Hint = "󰌵 ",
							},
						},
						permission = {
							enabled = true,
						},
						size = {
							enabled = true,
						},
					},
					icon = {
						directory_collapsed = nil,
						directory_empty = nil,
						directory_expanded = nil,
					},
					indentscope = {
						enabled = true,
						markers = {
							{ "│", "FylerIndentMarker" },
							{ "└", "FylerIndentMarker" },
						},
					},
					mappings = {
						["q"] = "CloseView",
						["<C-n>"] = "CloseView",
						["<CR>"] = "Select",
						-- ["l"] = "Select",
						["<C-t>"] = "SelectTab",
						["|"] = "SelectVSplit",
						["<C-v>"] = "SelectVSplit",
						["-"] = "SelectSplit",
						["<C-s>"] = "SelectSplit",
						-- ["p"] = "GotoParent",
						["="] = "GotoCwd",
						["."] = "GotoNode",
						["#"] = "CollapseAll",
						["<BS>"] = "CollapseNode",
						["h"] = "CollapseNode",
					},
					mappings_opts = {
						nowait = false,
						noremap = true,
						silent = true,
					},
					follow_current_file = true,
					-- Automatically updated finder on file system events
					watcher = {
						enabled = true,
					},
					win = {
						border = vim.o.winborder == "" and "single" or vim.o.winborder,
						buf_opts = {
							bufhidden = "hide",
							buflisted = false,
							buftype = "acwrite",
							expandtab = true,
							filetype = "fyler",
							shiftwidth = 2,
							syntax = "fyler",
							swapfile = false,
						},
						kind = "replace",
						kinds = {
							float = {
								height = "70%",
								width = "70%",
								top = "10%",
								left = "15%",
							},
							replace = {},
							split_above = {
								height = "70%",
							},
							split_above_all = {
								height = "70%",
								win_opts = {
									winfixheight = true,
								},
							},
							split_below = {
								height = "70%",
							},
							split_below_all = {
								height = "70%",
								win_opts = {
									winfixheight = true,
								},
							},
							split_left = {
								width = "30%",
							},
							split_left_most = {
								width = "30%",
								win_opts = {
									winfixwidth = true,
								},
							},
							split_right = {
								width = "30%",
							},
							split_right_most = {
								width = "30%",
								win_opts = {
									winfixwidth = true,
								},
							},
						},
						win_opts = {
							concealcursor = "nvic",
							conceallevel = 3,
							cursorline = false,
							number = false,
							relativenumber = false,
							signcolumn = "no",
							winhighlight = "Normal:FylerNormal,NormalNC:FylerNormalNC",
							wrap = false,
						},
					},
				},
			},
		},
		keys = {
			{ "<C-n>", "<Cmd>Fyler kind=float<Cr>", desc = "Open Fyler View" },
		},
	},
}
