return {
	{
		-- show and work with multiple cursors
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		enabled = false,
		init = function()
			vim.g.VM_maps = {
				-- TODO: find other keymap, this one is used
				-- ["Find Under"] = "<C-y>",
				-- ["Find Subword Under"] = "<C-y>",
			}
		end,
	},

	{
		-- adds smooth, customizable animations to text operations like yank, paste, search, undo/redo, and more.
		"rachartier/tiny-glimmer.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			overwrite = {
				search = {
					enabled = true,
				},
				undo = {
					enabled = true,
				},
				redo = {
					enabled = true,
				},
			},
			autoreload = true,
		},
	},

	{
		-- move any selection in any direction
		"nvim-mini/mini.move",
		event = "VeryLazy",
		opts = {},
	},

	{
		-- animated scrolling
		"folke/snacks.nvim",
		priority = 900,
		lazy = false,
		---@type snacks.config
		opts = {
			scroll = {
				enabled = true,
				animate = {
					duration = { step = 15, total = 100 },
					easing = "linear",
				},
				animate_repeat = {
					delay = 50,
					duration = { step = 5, total = 50 },
					easing = "linear",
				},
			},
		},
	},

	{
		-- Change the w, e, b motions. Move by subwords and skip insignificant punctuation.
		"chrisgrieser/nvim-spider",
		enabled = false,
		keys = {
			{ "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
			{ "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
			{ "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
			{ "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" } },
		},
	},

	{
		-- Navigate the code with search labels
		"folke/flash.nvim",
		event = { "BufReadPost", "BufNewFile" },
		---@type Flash.Config
		opts = {
			modes = {
				search = {
					enabled = false,
				},
				char = {
					enabled = false,
					jump_labels = false,
				},
			},
		},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            -- disabled to use the default "S" keymap
            -- { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            -- do something remotely and go back
            -- d/c/y then r, search and go like with "s", then a motion like iw for inner word, or i and a closing character, or use "s" 
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            -- v/d/c/y then R, search and select the letter which surrounds the desired area
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            -- use C-s to enable/disable flash in "/" search
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
            -- "f" : search next character, then f or ; to next, F to previous
            -- "t" : same as "f" but goes just before
        },
	},

	{
		-- apply neovim indent config from what file already contains (tab, spaces, etc)
		"NMAC427/guess-indent.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_tab_options = {
				["tabstop"] = 4,
				["shiftwidth"] = 4,
				["softtabstop"] = 4,
			},
		},
		keys = {
			{
				"<leader>ri",
				"<CMD>GuessIndent<CR>",
				mode = "n",
				desc = "Reload GuessIndent",
			},
		},
	},

	{
		-- animated cursor
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		enabled = false,

		opts = {
			-- Smear cursor when switching buffers or windows.
			smear_between_buffers = true,

			-- Smear cursor when moving within line or to neighbor lines.
			-- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
			smear_between_neighbor_lines = true,

			-- Draw the smear in buffer space instead of screen space when scrolling
			scroll_buffer_space = true,

			-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
			-- Smears and particles will look a lot less blocky.
			legacy_computing_symbols_support = true,

			-- Smear cursor in insert mode.
			-- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
			smear_insert_mode = true,
			distance_stop_animating_vertical_bar = 0.1,

			stiffness = 0.5,
			trailing_stiffness = 0.5,
			matrix_pixel_threshold = 0.5,
		},
	},
}
