local close_hidden_buffers = function()
	local visible_bufs = {}

	-- identify visible buffers
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		visible_bufs[vim.api.nvim_win_get_buf(win)] = true
	end

	-- dont save other buffers
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and not visible_bufs[bufnr] then
			-- keep it if something is unsaved
			local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
			if not modified then
				pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
			end
		end
	end

	return true
end

return {
	"rmagatti/auto-session",
	cmd = "AutoSession",
	keys = {
		{ "<leader>ws", "<cmd>AutoSession search<CR>", desc = "Session search" },
		{ "<leader>wd", "<cmd>AutoSession delete<CR>", desc = "Session delete" },
	},

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		auto_restore = false,
		-- suppress session restore/create in certain directories
		suppressed_dirs = { "~/", "/" },
		-- no save at all when there is only a dashboard
		bypass_save_filetypes = { "snacks_dashboard" },
		-- exclude theses filetypes when saving
		close_filetypes_on_save = { "checkhealth" },
		-- dont save hidden buffers
		pre_save_cmds = { close_hidden_buffers },
	},
}
