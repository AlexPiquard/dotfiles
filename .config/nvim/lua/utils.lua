local M = {}
function M.is_dotfiles()
	local dotfiles_path = vim.fs.normalize(vim.env.HOME .. "/dotfiles")
	local current_dir = vim.fs.normalize(vim.uv.cwd() or "")
	return vim.startswith(current_dir, dotfiles_path)
end

---@param cmd string
function M.open_cmd_win(cmd)
	local width = math.floor(vim.o.columns * 0.85)
	local height = math.floor(vim.o.lines * 0.85)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "none",
	})

	vim.fn.jobstart(cmd, {
		term = true,
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})

	vim.cmd("startinsert")
end

return M
