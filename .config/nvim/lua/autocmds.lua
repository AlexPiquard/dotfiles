-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- disable cursorline highlight on specific buffers
local disable_cursorline_group = vim.api.nvim_create_augroup("DisableCursorline", { clear = true })
local disabled_filetypes = { "snacks_picker_input", "snacks_dashboard", "opencode_ask" }
local disabled_buftypes = { "terminal", "nofile" }
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	group = disable_cursorline_group,
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local bt = vim.bo[args.buf].buftype

		if vim.tbl_contains(disabled_filetypes, ft) or vim.tbl_contains(disabled_buftypes, bt) then
			vim.opt_local.cursorline = false
		end
	end,
})
