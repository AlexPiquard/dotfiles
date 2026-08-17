return {
	{
		-- Set of operators and textobjects to search/select/edit sandwiched texts.
		-- keys are : sa, sd and sr
		"machakann/vim-sandwich",
		event = "BufReadPost",
	},
	{
		-- Auto pairs
		-- Automatically inserts a matching closing character
		-- when you type an opening character like `"`, `[`, or `(`.
		"windwp/nvim-autopairs",
		event = "BufReadPost",
		opts = {
			-- alt-e to add the closing thing after word
			fast_wrap = {},
			disable_filetype = { "markdown", "snacks_picker_input" },
			ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
			-- disable in string
			enable_bracket_in_quote = false,
			-- (|)) -> ((|))
			enable_check_bracket_line = true,
		},
	},
}
