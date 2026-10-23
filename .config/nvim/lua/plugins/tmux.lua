return {
	{
		"smart-splits-nvim/smart-splits.nvim",
		lazy = false,
		dependencies = {
			{ "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux" },
		},
		opts = {
			mux = { backend = "smart-splits-backend-tmux" },
			move = { at_edge = "split" },
		},
		keys = {
			{
				"<C-h>",
				function()
					require("smart-splits").move_cursor_left()
				end,
			},
			{
				"<C-j>",
				function()
					require("smart-splits").move_cursor_down()
				end,
			},
			{
				"<C-k>",
				function()
					require("smart-splits").move_cursor_up()
				end,
			},
			{
				"<C-l>",
				function()
					require("smart-splits").move_cursor_right()
				end,
			},
			{
				"<M-h>",
				mode = "n",
				function()
					require("smart-splits").resize_left()
				end,
			},
			{
				"<M-j>",
				mode = "n",
				function()
					require("smart-splits").resize_down()
				end,
			},
			{
				"<M-k>",
				mode = "n",
				function()
					require("smart-splits").resize_up()
				end,
			},
			{
				"<M-l>",
				mode = "n",
				function()
					require("smart-splits").resize_right()
				end,
			},
		},
	},
}
