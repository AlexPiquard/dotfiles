local M = {}
function M.is_dotfiles()
	local dotfiles_path = vim.fs.normalize(vim.env.HOME .. "/dotfiles")
	local current_dir = vim.fs.normalize(vim.uv.cwd() or "")
	return vim.startswith(current_dir, dotfiles_path)
end

return M
