return {
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
		event = { "BufReadPost", "BufNewFile" },
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
		-- split/join blocks of code
		"Wansmer/treesj",
		keys = { "<leader>m" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {},
	},
}
