local open_lazygit = function()
	Snacks.terminal("lazygit", { win = { position = "float" } })
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	desc = "Close terminals on vim leave",
	pattern = "*",
	callback = function()
		local buffers = vim.api.nvim_list_bufs()
		for _, bufnr in ipairs(buffers) do
			if vim.bo[bufnr].buftype == "terminal" then
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end
		end
	end,
})

return {
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
								and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
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
			"<leader>lg",
			function()
				open_lazygit()
			end,
			desc = "LazyGit",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git log [f]ile",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git [l]og",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git log [L]ine",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git [d]iff",
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
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "Lsp references",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"<leader>ft",
			function()
				Snacks.picker.treesitter()
			end,
			desc = "Treesitter",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>sH",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete buffer",
		},
		{
			"<leader>bD",
			"<cmd>:bd<cr>",
			desc = "Delete buffer and window",
		},
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
	},
}
